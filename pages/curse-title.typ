#let page(
  speciality: "Информационные системы и технологии",
  specialityCode: "6-05-0611-01",
  theme: "проектирование информационной системы управления заказами",
  group: "ИТП-41",
  student: "Фамилия И.О.",
  supervisor: "Фамилия И.О.",
  supervisorTitle: "доцент",
  documentType: "курсовой",
  year: 2026
) = {
  align(center)[
    #set text(size: 14pt)
    #set par(spacing: 24pt)

    МИНИСТЕРСТВО ОБРАЗОВАНИЯ РЕСПУБЛИКИ БЕЛАРУСЬ

    Учреждение образования\
    "Гомельский государственный технический университет имени П.О. Сухого"
    
    Факультет автоматизированных и информационных систем

    Кафедра "Информационные технологии"

    Специальность #specialityCode "#speciality"

    \  

    ПОЯСНИТЕЛЬНАЯ ЗАПИСКА\
    к #documentType работе
    
    #set par(spacing: 0.5em)
    по дисциплине: "#course"
    
    на тему: "#theme"
  ]

  v(1fr)

  align(left)[
    #set par(justify: true, first-line-indent: (amount: 9.5cm, all: true))

    Выполнил: студент гр. #group 
    
    #student
    
    Принял: #supervisorTitle 
    
    #supervisor
  ]

  v(1fr)

  align(right)[
    #set box(width: 1fr, stroke: (bottom: 0.5pt), none)
    #grid(
      align: left + bottom,
      gutter: 0.5em,
      columns: (auto, 120pt),
      [Дата проверки:], [#box()],
      [Дата допуска к защите:], [#box()],
      [Дата защиты:], [#box()],
      [Оценка работы:], [#box()],
    )
  ]

  v(1fr)

  [
    #set par(first-line-indent: 0pt)
    Подписи членов комиссии

    по защите курсового проекта: #box(width: 200pt, stroke: (bottom: 0.5pt), none)

    \
  ]

  align(center)[
    Гомель #year
  ]

  pagebreak()
}
