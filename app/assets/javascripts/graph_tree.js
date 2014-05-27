/**
 * Created by evg_rz on 13.05.14.
 */

/*
 *  Структура узла (NODE) дерева:
 *
 *      node: {
 *          profile_id      -> UNSIGNED INT (целочисленное >0)  -> ID профиля
 *          user_id         -> UNSIGNED INT (целочисленное >0)  -> ID пользователя
 *          name            -> STRING       (строка)            -> Имя профиля
 *          sex_id          -> TINYINT      (целочисленное 1/0) -> Пол (муж[1]/жен[0])
 *          relation_id     -> SMALLINT     (целочисленное 0-8) -> Вид отношений (автора[0]/отец[1]/мать[2]/сын[3]/дочь[4]/брат[5]/сестра[6]/муж[7]/жена[8])
 *          options { ... } -> OBJECT       (объект)            -> Дополнительные параметры
 *          family { ... }  -> STRUCTURE    (структура)         -> Вложенная структура дерева
 *      }
 *
 *  Структура (STRUCTURE) дерева
 *
 *      author: {                   -> Автор
 *          <NODE_PROPERTIES>       -> Свойства автора
 *          family {                -> Вся семья автора
 *              fathers: [          -> Отцы автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              mothers: [          -> Матери автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              brothers: [         -> Братья автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              sisters: [          -> Сестры автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              sons: [             -> Сыновья автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              daughters: [        -> Дочери автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              wives: [            -> Жены автора
 *                  node { ... },
 *                  node { ... }
 *              ],
 *              husbands: [         -> Мужья автора
 *                  node { ... },
 *                  node { ... }
 *              ]
 *          }
 *      }
 */

/*
 *  Класс вычисления координат и построения древа:
 *  reTree              - конструктор класса;
 *  sexing              - определение цвета по полу;
 *  validation          - валидация на существование свойств (пол, родственная связь, имя) необходимых для создания элемента
 *  relationToS         - переводит числовое представление родсвтенной связи в символьное
 *  scale               - функция изменения масштаба;
 *  constructElement    - построение элемента древа по заданным параметрам;
 *  constructTree       - построение древа;
 *  roundTree           - обход древа;
 */

function reTree(json, params) {

    /*
     * Конвертируем json в объект (если это необходимо);
     *
     * Создаем объект coordinates - все координаты данного класса;
     * Создаем подобъекты в coordinates:
     *      config      - общие,
     *      author      - автора,
     *      parents     - родителей,
     *      couple      - мужа и жены,
     *      sibs        - братьев и сестер,
     *      childrens   - детей
     *
     * Создаем экземпляр класса reKinetic;
     */

    this.obj = json instanceof Object ? json : eval('(' + json +')');

    this.coordinates = new Object();
    this.coordinates.config = new Object();
    this.coordinates.author = new Object();
    this.coordinates.parents = new Object();
    this.coordinates.couple = new Object();
    this.coordinates.sibs = new Object();
    this.coordinates.childrens = new Object();

    this.kinetic = new reKinetic(params);

   /*
    * config.devscale       - масштаб (конастанта) расположения элементов древа относительно друг-друга;
    * config.scale          - текущий масштаб (изменяемый) слоев относительно холста;
    *
    * author.x              - координата начальной точки (левого-верхнего угла) корня (автора) по оси X;
    * author.y              - координата начальной точки (левого-верхнего угла) корня (автора) по оси Y;
    * author.xcenter        - центр прямоугольника (фигура автора) по оси X;
    * author.ycenter        - центр прямоугольника (фигура автора) по оси X;
    *
    * sibs.tlvl             - уровень следующего сибса сверху (брата), начальное значение 1;
    * sibs.blvl             - уровень следующего сибса снизу (сестры), начальное значение 1;
    * sibs.deviation        - отклонение от центра сестры или брата;
    *
    * childrens.tlvl        - уровень следующего ребенка сверху (сына), начальное значение 1;
    * childrens.blvl        - уровень следующего ребенка снизу (дочери), начальное значение 1;
    * childrens.xdeviation  - отклонение от центра детей по оси X;
    * childrens.ydeviation  - отклонение от центра детей по оси Y;
    * childrens.direction   - направление отклонения (по отношению к родителю) {
    *             0 - центр (мать/отец детей не указаны);
    *             1 - право (между женой и автором);
    *            -1 - лево  (между мужем и автором);
    * };
    *
    * parents.xdeviation    - отклонение от центра родителей по оси X;
    * parents.ydeviation    - отклонение от центра родителей по оси Y;
    *
    * couple.deviation      - отклонение от центра мужа или жены;
    * couple.direction      - отклонение от центра для детей
    */

    this.coordinates.config.devscale = this.kinetic.params.stage.width / this.kinetic.params.config.scale * 5;
    this.coordinates.config.scale = 1;

    this.coordinates.author.x = this.kinetic.params.stage.width / 2 - this.kinetic.params.rectangle.width / 2;
    this.coordinates.author.y = this.kinetic.params.stage.height / 2 - this.kinetic.params.rectangle.height / 2;
    this.coordinates.author.xcenter = this.coordinates.author.x + this.kinetic.params.rectangle.width / 2;
    this.coordinates.author.ycenter = this.coordinates.author.y + this.kinetic.params.rectangle.height / 2;

    this.coordinates.sibs.tlvl = 1.5;
    this.coordinates.sibs.blvl = 1.5;
    this.coordinates.sibs.deviation = this.coordinates.config.devscale;

    this.coordinates.childrens.tlvl = 1.5;
    this.coordinates.childrens.blvl = 1.5;
    this.coordinates.childrens.xdeviation = this.coordinates.config.devscale;
    this.coordinates.childrens.ydeviation = this.coordinates.config.devscale;
    this.coordinates.childrens.direction = 0;

    this.coordinates.parents.xdeviation = this.coordinates.config.devscale / 2;
    this.coordinates.parents.ydeviation = this.coordinates.config.devscale;

    this.coordinates.couple.deviation = this.coordinates.config.devscale;
    this.coordinates.couple.direction = (this.coordinates.couple.deviation - Math.abs(this.coordinates.author.xcenter - this.coordinates.author.x)) / 2;

    this.roundTree(this.obj);

    if (!this.kinetic.params.config.ajax)
        this.kinetic.compilation();

}

/*
 * Определяет цвет фигуры по её полу
 */

reTree.prototype.sexing = function (sex) { return 0 < sex > 1 ? '#ccc' : sex ? '#bfefff' : '#fffacd'; }

/*
 * Валидация на выполнение всех условий при построении элементра древа
 */

reTree.prototype.validation = function (properties) { return properties.relation_id === '' ? false : true; }

/*
 * Переводит числовое представление родственной связи в символьное ( 0 -> автор; 1 -> отец; и тд)
 */

reTree.prototype.relationToS = function (relationNumber) {
    var relationString;
    switch (relationNumber) {
        case 0:
            relationString = 'автор';
            break;
        case 1:
            relationString = 'отец';
            break;
        case 2:
            relationString = 'мать';
            break;
        case 3:
            relationString = 'сын';
            break;
        case 4:
            relationString = 'дочь';
            break;
        case 5:
            relationString = 'брат';
            break;
        case 6:
            relationString = 'сестра';
            break;
        case 7:
            relationString = 'муж';
            break;
        case 8:
            relationString = 'жена';
            break;
        default:
            relationString = 'ошибка. несуществующая связь';
            break;
    }
    return relationString;
}

/*
 * Масштабирует и центрирует дерево относительно холста
 */

reTree.prototype.scale = function (scale) {

    for(layer in this.kinetic.layers) {
        //this.kinetic.layers[layer].offsetX(this.kinetic.layers[layer].x - this.kinetic.layers[layer].x / this.coordinates.config.scale);
        //this.kinetic.layers[layer].offsetY(this.kinetic.layers[layer].y - this.kinetic.layers[layer].y / this.coordinates.config.scale);
        this.kinetic.layers[layer].scale({ x: scale, y: scale });
        this.kinetic.layers[layer].draw();
    }

    this.coordinates.config.scale = scale;

}


/*
 * Построение элемента по заданным параметрам
 */

reTree.prototype.constructElement = function () {

}

/*
 * Строит дерево по заданным координатам, отрисовывает: фигуры, линии, текст
 */

reTree.prototype.constructTree = function (properties) {

    /*
     * Родственные связи {
     *      автор       ->      0
     *      отец        ->      1
     *      мать        ->      2
     *      сын         ->      3
     *      дочь        ->      4
     *      брат        ->      5
     *      сестра      ->      6
     *      муж         ->      7
     *      жена        ->      8
     * }
     * В зависимости от типа связи рисуем фигуру (круг/прямоугольник), линии (от автора), текст;
     * Если не хватает одного из основных параметров (имя, тип связи, пол) выходим из функции;
     */

    if (!this.validation(properties))
        return;

    switch (properties.relation_id) {
        case 0:                                         // автор
            this.kinetic.drawRect(
                this.coordinates.author.x,
                this.coordinates.author.y,
                this.sexing(properties.sex_id)
            );
            this.kinetic.drawText(
                this.coordinates.author.x,
                this.coordinates.author.ycenter - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.rectangle.width,
                properties.name + ', ' + properties.relation_id
            );
            break;
        case 1:                                         // отец
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.parents.xdeviation,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation;
            cLine[cLine.length] = this.coordinates.author.xcenter - this.coordinates.parents.xdeviation;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter - this.coordinates.parents.xdeviation - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            break;
        case 2:                                         // мать
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter + this.coordinates.parents.xdeviation,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.parents.xdeviation;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter + this.coordinates.parents.xdeviation - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            break;
        case 3:                                         // сын
            var xcenter = this.coordinates.author.xcenter
                          + this.coordinates.childrens.xdeviation * this.coordinates.childrens.tlvl
                          + this.coordinates.couple.direction * this.coordinates.childrens.direction;
            this.kinetic.drawCircle(
                xcenter,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.couple.deviation / 2 * this.coordinates.childrens.direction;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.couple.deviation / 2 * this.coordinates.childrens.direction;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                xcenter - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            this.coordinates.childrens.tlvl++;
            break;
        case 4:                                         // дочь
            var xcenter = this.coordinates.author.xcenter
                          + this.coordinates.childrens.xdeviation * this.coordinates.childrens.blvl
                          + this.coordinates.couple.direction * this.coordinates.childrens.direction;
            this.kinetic.drawCircle(
                xcenter,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation + this.coordinates.childrens.xdeviation,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.couple.deviation / 2 * this.coordinates.childrens.direction;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.couple.deviation / 2 * this.coordinates.childrens.direction;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation / 2;
            cLine[cLine.length] = xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                xcenter - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation + this.coordinates.childrens.xdeviation - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            this.coordinates.childrens.blvl++;
            break;
        case 5:                                         // брат
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.tlvl,
                this.coordinates.author.ycenter,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.tlvl;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.tlvl;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.tlvl - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            this.coordinates.sibs.tlvl++;
            break;
        case 6:                                         // сестра
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.blvl,
                this.coordinates.author.ycenter + this.coordinates.sibs.deviation,
                this.sexing(properties.sex_id)
            );
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.sibs.deviation * this.coordinates.sibs.blvl;
            cLine[cLine.length] = this.coordinates.author.ycenter - this.coordinates.parents.ydeviation / 2;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.sibs.deviation * this.coordinates.sibs.blvl;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.blvl - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter + this.coordinates.sibs.deviation - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            this.coordinates.sibs.blvl++;
            break;
        case 7:                                         // муж
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.couple.deviation,
                this.coordinates.author.ycenter,
                this.sexing(properties.sex_id)
            );
            this.coordinates.childrens.direction = 1;
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter - this.coordinates.couple.deviation;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter - this.coordinates.couple.deviation - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            break;
        case 8:                                         // жена
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter + this.coordinates.couple.deviation,
                this.coordinates.author.ycenter,
                this.sexing(properties.sex_id)
            );
            this.coordinates.childrens.direction = 1;
            var cLine = new Array();
            cLine[cLine.length] = this.coordinates.author.xcenter;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            cLine[cLine.length] = this.coordinates.author.xcenter + this.coordinates.couple.deviation;
            cLine[cLine.length] = this.coordinates.author.ycenter;
            //this.kinetic.drawLine(cLine);
            this.kinetic.drawText(
                this.coordinates.author.xcenter + this.coordinates.couple.deviation - this.kinetic.params.circle.radius,
                this.coordinates.author.ycenter - this.kinetic.params.text.fontSize / 2,
                this.kinetic.params.circle.radius * 2,
                properties.name + ', ' + properties.relation_id
            );
            break;
        default:                                        // ошибка -> выход
            return;
    }

}

/*
 * Обход JSON и передача нужных для построения древа данных в функцию constructTree
 */

reTree.prototype.roundTree = function (object) {

    var props = new Array();

    for(var prop in object) {
        if(object[prop] instanceof Object)
            this.roundTree(object[prop]);
        else
            props[prop] = object[prop];
    }

    this.constructTree(props);

}

/*
 *  Класс по работе с Kinetic:
 *  reKinetic       - конструктор класса [холст, слои, параметры фигур];
 *  drawLine        - рисуем линию;
 *  drawCircle      - рисуем круг;
 *  drawRect        - рисуем прямоугольник;
 *  drawText        - отрисовываем текст;
 *  compilation     - отрисовываем все фигуры на холсте;
 */

function reKinetic(parameters) {

    this.params = new Object();

    this.params.config = new Object();              // общие параметры
    this.params.config.ajax = parameters.ajax;
    this.params.config.max_scale = 1;
    this.params.config.min_scale = 250;

    /*
     * Если мастшаб (parameters.scale) больше (меньше как число) максимального (this.params.config.max_scale), тогда используем максимальный
     * Если мастшаб (parameters.scale) меньше (больше как число) минимального (this.params.config.min_scale), тогда используем минимальный
     */

    this.params.config.scale = parameters.scale < this.params.config.max_scale ? this.params.config.max_scale : parameters.scale > this.params.config.min_scale ? this.params.config.min_scale : parameters.scale;

    this.params.stage = new Object();               // параметры холста
    this.params.stage.container = parameters.container;
    this.params.stage.width = parameters.width;
    this.params.stage.height = parameters.height;
    this.params.stage.draggable = parameters.draggable;

    this.params.circle = new Object();              // параметры круга
    this.params.circle.radius = this.params.stage.width / this.params.config.scale;
    this.params.circle.stroke = '#333';
    this.params.circle.strokeWidth = 1;

    this.params.rectangle = new Object();           // параметры прямоугольника
    this.params.rectangle.width = this.params.stage.width / (this.params.config.scale / 4);
    this.params.rectangle.height = this.params.stage.width / (this.params.config.scale / 2);
    this.params.rectangle.stroke = '#900';
    this.params.rectangle.strokeWidth = 2;

    this.params.line = new Object();                // параметры линий
    this.params.line.stroke = 'black';
    this.params.line.strokeWidth = 2;
    this.params.line.lineCap = 'round';
    this.params.line.lineJoin = 'round';

    this.params.text = new Object();                // параметры текста
    this.params.text.fontSize = (this.params.stage.width / 1.5) / this.params.config.scale;
    this.params.text.fontFamily = 'Tahoma';
    this.params.text.align = 'center';
    this.params.text.fill = '#000';

    this.stage = new Kinetic.Stage({                // создаем холст
        name: 'tree_stage',
        container: this.params.stage.container,
        width: this.params.stage.width ,
        height: this.params.stage.height,
        draggable: this.params.stage.draggable
    });

    this.layers = new Object();

    this.layers.lines = new Kinetic.Layer({         // слой с линиями
        name: 'lines_layer'
    });

    this.layers.figures = new Kinetic.Layer({       // слой с фигурам
        name: 'figures_layer'
    });

    this.layers.text = new Kinetic.Layer({          // слой с текстом
        name: 'text_layer'
    });

    this.shapes = new Object();
    this.shapes.lines = new Array();                // массив линий
    this.shapes.figures = new Array();              // массив фигур
    this.shapes.text = new Array();                 // массив текста

    /*
     * Прекомпиляция для имитации пошагового построения
     * используется в ajax-script, иначе компиляция выполняется
     * после прорисовки всех объектов на холсте в явном виде
     */

    if (this.params.config.ajax)
        this.compilation();

}

/*
 * Рисуем линию по заданным параметрам и записываем её в массив линий
 */

reKinetic.prototype.drawLine = function (points) {

    this.shapes.lines[this.shapes.lines.length] = new Kinetic.Line({
        points: points,
        stroke: this.params.line.stroke,
        strokeWidth: this.params.line.strokeWidth,
        lineCap: this.params.line.lineCap,
        lineJoin: this.params.line.lineJoin
    });

    this.layers.lines.add(this.shapes.lines[this.shapes.lines.length - 1]);
    this.layers.lines.draw();

}

/*
 * Рисуем круг по заданным параметрам и записываем его в массив фигур
 */

reKinetic.prototype.drawCircle = function (x, y, fill) {

    this.shapes.figures[this.shapes.figures.length] = new Kinetic.Circle({
        x: x,
        y: y,
        radius: this.params.circle.radius,
        fill: fill,
        stroke: this.params.circle.stroke,
        strokeWidth: this.params.circle.strokeWidth
    });

    this.layers.figures.add(this.shapes.figures[this.shapes.figures.length - 1]);
    this.layers.figures.draw();

}

/*
 * Рисуем прямоугольник по заданным параметрам и записываем его в массив фигур
 */

reKinetic.prototype.drawRect = function (x, y, fill) {

    this.shapes.figures[this.shapes.figures.length] = new Kinetic.Rect({
        x: x,
        y: y,
        width: this.params.rectangle.width,
        height: this.params.rectangle.height,
        fill: fill,
        stroke: this.params.rectangle.stroke,
        strokeWidth: this.params.rectangle.strokeWidth
    });

    this.layers.figures.add(this.shapes.figures[this.shapes.figures.length - 1]);
    this.layers.figures.draw();

}

/*
 * Рисуем текст по заданным параметрам и записываем его в массив текста
 */

reKinetic.prototype.drawText = function (x, y, width, text) {

    this.shapes.text[this.shapes.text.length] = new Kinetic.Text({
        x: x,
        y: y,
        text: text,
        fontSize: this.params.text.fontSize,
        fontFamily: this.params.text.fontFamily,
        width: width,
        align: this.params.text.align,
        fill: this.params.text.fill
    });

    this.layers.text.add(this.shapes.text[this.shapes.text.length - 1]);
    this.layers.text.draw();

}

/*
 * Добавляет слои на холст; явный вызов компиляции объектов. [noAJAX]
 * если используется ajax, комплияция не требуется, т.к она выполняется в начале
 */

reKinetic.prototype.compilation = function () {

    for(var layer in this.layers)
        this.stage.add(this.layers[layer]);

}

/*
 * Всякая хрень:
 *
 * 1) reTree.prototype.roundTree       - Функция обхода дерева;
 * 2) reTree.prototype.outputError     - Вывод ошибки;
 * 3) .on('mouseover', function () {   - Пример задания функции на событие для фигуры;
 */

/*
 reTree.prototype.outputError = function (object, prop, lvl, step, isObject) {

 if (isObject)
 this.out.innerHTML += '<div style="margin-left:' + (lvl * step) + 'px;"><b>' + prop + '</b></div>';
 else
 this.out.innerHTML += '<div style="margin-left:' + (lvl * step) + 'px;">' + prop + ' :' + object[prop] + ' </div>';

 }
 */

/*
 reTree.prototype.roundTree = function (object, lvl) {
 lvl++;
 for(var prop in object) {
 if(object[prop] instanceof Object) {
 //this.outputError(object, prop, lvl, 10, true);
 this.roundTree(object[prop], lvl);
 } //else
 //this.outputError(object, prop, lvl, 10, false);
 }
 }
 */

/*
 this.shapes.text[this.shapes.text.length - 1].on('mouseover', function () {
 document.body.style.cursor = 'pointer';
 });
 this.shapes.text[this.shapes.text.length - 1].on('mouseout', function () {
 document.body.style.cursor = 'default';
 });
 */