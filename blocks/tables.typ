// БЛОК ТАБЛИЦЫ: общая функция составления таблиц по ГОСТ 7.32.
// Один вызов формирует название («Таблица 3.4 -- Название») над таблицей
// и саму таблицу по входным данным:
//   - title — название таблицы (обязательно, отражает её содержание);
//   - header — строка заголовка: массив ячеек (выделяется полужирным
//     автоматически правилом styles/extended: show table.cell.where(y: 0));
//   - rows — строки данных: массив массивов ячеек;
//   - part — буква приложения: нумерация «Таблица Б.1». Буква определяется
//     АВТОМАТИЧЕСКИ из state("appendix"), публикуемого #appendix
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

  let tbl = if header == none {
    table(
      columns: cols,
      align: align,
      stroke: stroke,
      inset: inset,
      ..rows.flatten(),
    )
  } else {
    table(
      columns: cols,
      align: align,
      stroke: stroke,
      inset: inset,
      table.header(..header),
      ..rows.flatten(),
    )
  }

  [#caption #tbl]
}