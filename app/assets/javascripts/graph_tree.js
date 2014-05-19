/**
 * Created by evg_rz on 13.05.14.
 */

/*
 *  Класс вычисления координат и построения древа
 *  reTree              - конструктор класса
 *  roundTree           - обход древа
 *  sexing              - определение цвета по полу
 *  constructFigures    - рисуем фигуры по заданным координатам
 *  constructLines      - рисуем линии по заданным координатам
 *  constructTree       - построение древа (объединение методов constructFigures и constructLines
 *  в целостную конструкцию)
 */

function reTree(out, obj) {

    this.out = out;
    this.obj = obj;
    this.coordinates = new Object();
    this.coordinates.author = new Object();
    this.kinetic = new reKinetic('tree_canvas', 1000, 1000);
    this.coordinates.author.width = this.kinetic.params.stage.width / 2 - (this.kinetic.params.rectangle.width / 2);
    this.coordinates.author.height = this.kinetic.params.stage.height / 2 - (this.kinetic.params.rectangle.height / 2);
    this.roundTree(this.obj, 0);
    this.kinetic.compilation();

}

reTree.prototype.sexing = function (sex) {
    return sex?'#bfefff':'#fffacd';
}

reTree.prototype.constructLines = function (properties) {

}

reTree.prototype.constructTree = function (properties) {

    switch (properties[3]) {
        case 0:     // author
            this.kinetic.drawRect(
                this.coordinates.author.width,
                this.coordinates.author.height,
                this.sexing(properties[4])
            );
            break;
        case 1:     // father
            this.kinetic.drawCircle(
                0,
                0,
                this.sexing(properties[6])
            );
            break;
        case 2:     // mother
            this.kinetic.drawCircle(
                100,
                0,
                this.sexing(properties[6])
            );
            break;
        case 3:     // son
            this.kinetic.drawCircle(
                200,
                0,
                this.sexing(properties[6])
            );
            break;
        case 4:     // daughter
            this.kinetic.drawCircle(
                300,
                0,
                this.sexing(properties[6])
            );
            break;
        case 5:     // brother
            this.kinetic.drawCircle(
                400,
                0,
                this.sexing(properties[6])
            );
            break;
        case 6:     // sister
            this.kinetic.drawCircle(
                500,
                0,
                this.sexing(properties[6])
            );
            break;
        case 7:     // husband
            this.kinetic.drawCircle(
                600,
                0,
                this.sexing(properties[6])
            );
            break;
        case 8:     // wife
            this.kinetic.drawCircle(
                700,
                0,
                this.sexing(properties[6])
            );
            break;
        default:    // error -> exit
            return;
    }

}

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
 *  Класс по работе с Kinetic
 *  reKinetic       - конструктор класса [холст, слои, параметры фигур]
 *  drawLine        - рисуем линию
 *  drawCircle      - рисуем круг
 *  drawRect        - рисуем прямоугольник
 *  compilation     - отрисовываем все фигуры на холсте
 */

function reKinetic(stageContainer, stageWidth, stageHeight) {

    this.params = new Object();                     // параметры холста, фигур и линий

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

    this.layers = new Object();                     // создаем слои
    this.layers.figures = new Kinetic.Layer({       // слой с фигурам
        name: 'figures_layer'
    });
    this.layers.lines = new Kinetic.Layer({         // слой с линиями
        name: 'lines_layer'
    });

    this.shapes = new Object();                     // массивы фигур и линий
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
 * reTree.prototype.roundTree       - Функция обхода дерева
 * reTree.prototype.outputError     - Вывод ошибки
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