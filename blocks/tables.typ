// БЛОК ТАБЛИЦЫ: общая функция составления таблиц по ГОСТ 7.32.
// Один вызов формирует название («Таблица 3.4 -- Название») над таблицей
// и саму таблицу по входным данным:
//   - title — название таблицы (обязательно, отражает её содержание);
//   - header — строка заголовка: массив ячеек (выделяется полужирным
//     автоматически правилом styles/extended: show table.cell.where(y: 0));
//   - rows — строки данных: массив массивов ячеек;
//   - part — буква приложения: нумерация «Таблица Б.1». Буква определяется
//     АВТОМАТАТИЧЕСКИ из state("appendix"), публикуемого #appendix
//     (styles/extended.typ), поэтому в приложении part передавать не нужно;
//     явный part остаётся как переопределение;
//   - columns, align, stroke, inset — параметры оформления элемента #table.
// Нумерация по ГОСТ: в пределах раздела «номер раздела.номер таблицы»
// (например «Таблица 4.2»), счётчик сбрасывается до 1 при переходе на новый
// раздел; если разделов нет — сквозная («Таблица 1», «Таблица 2»);
// в приложении нумерация по букве приложения («Таблица Б.1»).
// Сброс счётчиков выполняют styles/extended (при заголовке раздела —
// уровень 1) и функция appendix (при начале приложения).
// Пробельные строки до и после таблицы ставятся в тексте отчёта вручную.
//
// ЗАЩИТА НАЗВАНИЯ ОТ ОТРЫВА ОТ ТАБЛИЦЫ. Название не должно оставаться одно
// в конце страницы, пока сама таблица целиком переходит на следующую.
// При этом сама таблица обязана остаться РАЗРЫВНОЙ, а её шапка при разрыве
// повторяться на странице (table.header).
//
// Механизм: если название вместе с таблицей помещается на одной странице, оба
// элемента объединяются в block(breakable: false) — такой блок Typst не
// переносит и не разрывает, поэтому название всегда уезжает вместе с
// таблицей. Разрывной остаётся только сам #table.
//
// Почему block(breakable: false) не всегда: он запрещает разрыв не только
// самому блоку, но и вложенной в него таблице. Для таблицы длиннее страницы
// непоместившаяся таблица переполняет полосу: последние строки наезжают на
// колонтитул и друг на друга (проверено на таблице из 45 строк). Поэтому
// неразрывный блок применяется только там, где содержимое заведомо помещается
// на странице; таблицы длиннее страницы остаются обычными разрывными.
//
// Почему не table.header(repeat: false) для названия: такой приём не даёт
// нужной гарантии. Перебором пяти вариантов расстановки table.header
// проверено: повторяющиеся строки заголовка Typst не отрывает от таблицы, а
// неповторяющиеся отрывает (название остаётся одно в конце страницы), а
// повторяющееся название дублируется на каждой следующей странице. Оба
// варианта не годятся.
//
// Почему не pagebreak по остатку места на странице (context + here()):
// styles/extended содержит `show regex("[a-zA-Z]"): set text(style: "italic")`.
// В сочетании с here() внутри context движок разметки упирается в предел
// глубины группировки, и сборка падает с «maximum grouping depth exceeded».
// Проверено на минимальных примерах: без правила regex компилируется, с ним — нет.

// Поле страницы как длина. page.margin.* возвращает relative-величину вида
// 0% + 56.69pt, с которой работает арифметика. При поле auto величина не
// число — тогда возвращается none и защита от отрыва не проверяется.
#let page-margin-length(m) = if type(m) == length or type(m) == relative {
  m
} else {
  none
}

// Запас от высоты полосы набора: неразрывный блок включается, только когда
// содержимое гарантированно помещается на странице. Запас покрывает
// погрешность измерения и отбивку сверху.
#let table-fit-margin = 1em

#let table-block(
  title: none,
  header: none,
  rows: (),
  part: none,
  columns: auto,
  align: auto,
  stroke: 0.5pt,
  inset: 5pt,
) = context {
  // Буква приложения: если part не передан, определяется автоматически из
  // state("appendix"), которую публикует #appendix (styles/extended.typ).
  // Весь блок обёрнут в context, чтобы state.get() возвращал значение,
  // а не контент.
  let part = if part == none { state("appendix").get() } else { part }

  let c = counter(if part == none { "tab" } else { "tab-" + part })
  c.step()

  let caption = if part == none {
    context {
      let sec = counter("sec").get().first()
      let n = counter("tab").get().first()
      if sec > 0 [
        Таблица #(str(sec) + "." + str(n)) -- #title
      ] else [
        Таблица #str(n) -- #title
      ]
    }
  } else {
    context {
      let n = counter("tab-" + part).get().first()
      [Таблица #(part + "." + str(n)) -- #title]
    }
  }

  // Число колонок: явный параметр или по первой строке (шапке).
  let cols = if columns == auto {
    if header != none { header.len() }
    else if rows.len() > 0 { rows.first().len() }
    else { 1 }
  } else { columns }

  // Шапка помечена table.header: при разрыве таблицы она повторяется на
  // каждой следующей странице.
  let head = if header == none {
    ()
  } else {
    (table.header(..header),)
  }

  let tbl = table(
    columns: cols,
    align: align,
    stroke: stroke,
    inset: inset,
    ..head,
    ..rows.flatten(),
  )

  let body = [#caption #tbl]

  // Защита названия от отрыва от таблицы. Высота содержимого измеряется в
  // блоке ШИРИНОЙ ПОЛОСЫ НАБОРА: без явной ширины measure считает таблицу по
  // естественной ширине (столбцы сжимаются, высота занижается в разы).
  // Поле auto не раскрывается в словарь, поэтому при page(margin: auto)
  // защита просто не проверяется и таблица остаётся разрывной.
  let margins = page.margin
  let frame-height = none
  let text-width = none
  if type(margins) == dictionary {
    let top = page-margin-length(margins.top)
    let bottom = page-margin-length(margins.bottom)
    let left = page-margin-length(margins.left)
    let right = page-margin-length(margins.right)
    let known = top != none and bottom != none
    let known = known and left != none and right != none
    if known {
      frame-height = page.height - top - bottom
      text-width = page.width - left - right
    }
  }

  if frame-height != none {
    let body-height = measure(block(width: text-width, body)).height
    let fit-margin = table-fit-margin.to-absolute()
    if body-height + fit-margin <= frame-height {
      block(breakable: false, body)
    } else {
      body
    }
  } else {
    body
  }
}
