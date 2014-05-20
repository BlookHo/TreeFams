/**
 * Created by evg_rz on 13.05.14.
 */

/*
 *  Класс вычисления координат и построения древа:
 *  reTree              - конструктор класса;
 *  roundTree           - обход древа;
 *  sexing              - определение цвета по полу;
 *  constructTree       - построение древа;
 */

function reTree(out, obj) {

    this.out = out;
    this.obj = obj;

    this.coordinates = new Object();
    this.coordinates.author = new Object();
    this.coordinates.parents = new Object();
    this.coordinates.couple = new Object();
    this.coordinates.sibs = new Object();
    this.coordinates.childrens = new Object();

    this.kinetic = new reKinetic('tree_canvas', 1000, 1000);

   /*
    * author.x              - координата начальной точки (левого-верхнего угла) корня (автора) по оси X;
    * author.y              - координата начальной точки (левого-верхнего угла) корня (автора) по оси Y;
    * author.xcenter        - центр прямоугольника (фигура автора) по оси X;
    * author.ycenter        - центр прямоугольника (фигура автора) по оси X;
    *
    * sibs.rlvl             - уровень следующего сибса с правой стороны (сестры), начальное значение 0;
    * sibs.llvl             - уровень следующего сибса с левой стороны (брата), начальное значение 0;
    * sibs.deviation        - отклонение от центра сестры или брата;
    *
    * childrens.rlvl        - уровень следующего ребенка с правой стороны (дочери), начальное значение 0;
    * childrens.llvl        - уровень следующего ребенка с левой стороны (сына), начальное значение 0;
    * childrens.xdeviation  - отклонение от центра детей по оси X;
    * childrens.ydeviation  - отклонение от центра детей по оси Y;
    * childrens.direction   - направление отклонения (по отношению к родителю) {
    *       0 - центр (мать/отец детей не указаны);
    *       1 - лево (между мужем и автором);
    *       2 - право (между женой и автором);
    * };
    *
    * parents.xdeviation    - отклонение от центра родителей по оси X;
    * parents.ydeviation    - отклонение от центра родителей по оси Y;
    *
    * couple.deviation      - отклонение от центра мужа или жены;
    * couple.direction      - направление
    */

    this.coordinates.author.x = this.kinetic.params.stage.width / 2 - this.kinetic.params.rectangle.width / 2;
    this.coordinates.author.y = this.kinetic.params.stage.height / 2 - this.kinetic.params.rectangle.height / 2;
    this.coordinates.author.xcenter = this.coordinates.author.x + this.kinetic.params.rectangle.width / 2;
    this.coordinates.author.ycenter = this.coordinates.author.y + this.kinetic.params.rectangle.height / 2;

    this.coordinates.sibs.rlvl = 1;
    this.coordinates.sibs.llvl = 1;
    this.coordinates.sibs.deviation = 150;

    this.coordinates.childrens.rlvl = 0;
    this.coordinates.childrens.llvl = 0;
    this.coordinates.childrens.xdeviation = 150;
    this.coordinates.childrens.ydeviation = 150;
    this.coordinates.childrens.direction = 0;

    this.coordinates.parents.xdeviation = 100;
    this.coordinates.parents.ydeviation = 200;

    this.coordinates.couple.deviation = 150;
    this.coordinates.couple.direction = (this.coordinates.couple.deviation - Math.abs(this.coordinates.author.xcenter - this.coordinates.author.x)) / 2;

    this.roundTree(this.obj);

    this.kinetic.compilation();

}

/*
 * Определяет цвет фигуры по её полу
 */

reTree.prototype.sexing = function (sex) { return sex ? '#bfefff' : '#fffacd'; }

/*
 * Строит дерево по заданным координатам, отрисовывает фигуры и линии
 */

reTree.prototype.constructTree = function (properties) {

    switch (properties[3]) {
        case 0:     // author
            this.kinetic.drawRect(
                this.coordinates.author.x,
                this.coordinates.author.y,
                this.sexing(properties[4])
            );
            break;
        case 1:     // father
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.parents.xdeviation,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation,
                this.sexing(properties[6])
            );
            break;
        case 2:     // mother
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter + this.coordinates.parents.xdeviation,
                this.coordinates.author.ycenter - this.coordinates.parents.ydeviation,
                this.sexing(properties[6])
            );
            break;
        case 3:     // son
            var xcenter = this.coordinates.author.xcenter
                          -
                          this.coordinates.childrens.xdeviation * this.coordinates.childrens.llvl
                          +
                          this.coordinates.couple.course * this.coordinates.childrens.course;
            this.kinetic.drawCircle(
                xcenter,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation,
                this.sexing(properties[6])
            );
            this.coordinates.childrens.llvl++;
            if (this.coordinates.childrens.rlvl == 0)
                this.coordinates.childrens.rlvl++;
            break;
        case 4:     // daughter
            var xcenter = this.coordinates.author.xcenter
                          +
                          this.coordinates.childrens.xdeviation * this.coordinates.childrens.rlvl
                          +
                          this.coordinates.couple.course * this.coordinates.childrens.course;
            this.kinetic.drawCircle(
                xcenter,
                this.coordinates.author.ycenter + this.coordinates.childrens.ydeviation,
                this.sexing(properties[6])
            );
            this.coordinates.childrens.rlvl++;
            if (this.coordinates.childrens.llvl == 0)
                this.coordinates.childrens.llvl++;
            break;
        case 5:     // brother
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.sibs.deviation * this.coordinates.sibs.llvl,
                this.coordinates.author.ycenter,
                this.sexing(properties[6])
            );
            this.coordinates.sibs.llvl++;
            break;
        case 6:     // sister
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter + this.coordinates.sibs.deviation * this.coordinates.sibs.rlvl,
                this.coordinates.author.ycenter,
                this.sexing(properties[6])
            );
            this.coordinates.sibs.rlvl++;
            break;
        case 7:     // husband
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter - this.coordinates.couple.deviation,
                this.coordinates.author.ycenter,
                this.sexing(properties[6])
            );
            this.coordinates.sibs.llvl++;
            this.coordinates.childrens.course = -1;
            break;
        case 8:     // wife
            this.kinetic.drawCircle(
                this.coordinates.author.xcenter + this.coordinates.couple.deviation,
                this.coordinates.author.ycenter,
                this.sexing(properties[6])
            );
            this.coordinates.sibs.rlvl++;
            this.coordinates.childrens.course = 1;
            break;
        default:    // error -> exit
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
            props[props.length] = object[prop];
    }

    this.constructTree(props);

}

/*
 *  Класс по работе с Kinetic:
 *  reKinetic       - конструктор класса [холст, слои, параметры фигур];
 *  drawLine        - рисуем линию;
 *  drawCircle      - рисуем круг;
 *  drawRect        - рисуем прямоугольник;
 *  compilation     - отрисовываем все фигуры на холсте;
 */

function reKinetic(stageContainer, stageWidth, stageHeight) {

    this.params = new Object();

    this.params.stage = new Object();               // параметры холста
    this.params.stage.container = stageContainer;
    this.params.stage.width = stageWidth;
    this.params.stage.height = stageHeight;

    this.params.circle = new Object();              // параметры круга
    this.params.circle.radius = 30;
    this.params.circle.stroke = '#333';
    this.params.circle.strokeWidth = 2;

    this.params.rectangle = new Object();           // параметры прямоугольника
    this.params.rectangle.width = 100;
    this.params.rectangle.height = 50;
    this.params.rectangle.stroke = '#900';
    this.params.rectangle.strokeWidth = 2;

    this.params.line = new Object();                // параметры линий
    this.params.line.stroke = 'black';
    this.params.line.strokeWidth = 2;
    this.params.line.lineCap = '#333';
    this.params.line.lineJoin = '#333';

    this.stage = new Kinetic.Stage({                // создаем холст
        name: 'tree_stage',
        container: this.params.stage.container,
        width: this.params.stage.width ,
        height: this.params.stage.height,
        draggable: true
    });

    this.layers = new Object();

    this.layers.figures = new Kinetic.Layer({       // слой с фигурам
        name: 'figures_layer'
    });

    this.layers.lines = new Kinetic.Layer({         // слой с линиями
        name: 'lines_layer'
    });

    this.shapes = new Object();
    this.shapes.figures = new Array();              // массив фигур
    this.shapes.lines = new Array();                // массив линий

}

/*
 * Рисуем линию по заданным параметрам и записываем её в массив линий
 */

reKinetic.prototype.drawLine = function (points) {

    this.shapes.lines[this.shapes.lines.length] = new Kinetic.Line({
        points: [points],
        stroke: this.params.line.stroke,
        strokeWidth: this.params.line.strokeWidth,
        lineCap: this.params.line.lineCap,
        lineJoin: this.params.line.lineJoin
    });

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

}

/*
 * Обходим массивы с фигурами и линиями
 * добавляем фигуры и линии к соответствующим слоям
 * обходим массив со слоями и добавляем слои на холст
 */

reKinetic.prototype.compilation = function () {

    for(var figure in this.shapes.figures)
        this.layers.figures.add(this.shapes.figures[figure]);

    for(var line in this.shapes.lines)
        this.layers.lines.add(this.shapes.lines[line]);

    for(var layer in this.layers)
        this.stage.add(this.layers[layer]);
}


/*
 * Всякая хрень:
 *
 * reTree.prototype.roundTree       - Функция обхода дерева;
 * reTree.prototype.outputError     - Вывод ошибки;
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