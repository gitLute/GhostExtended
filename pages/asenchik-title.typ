// Стиль оформления титульного листа для предмета "РПБДИС".

#let page(
  number: 1, 
  course: "РПБДИС",
  theme: "бд",
  group: "ИТП-21",
  student: "Лосев М.А.",
  supervisor: "Асенчик О.Д.",
  supervisorTitle: "доцент",
  year: 2026,
  variant: 1
) = {
  align(center)[
    #set text(size: 14pt)
    #set par(spacing: 24pt)

    МИНИСТЕРСТВО ОБРАЗОВАНИЯ РЕСПУБЛИКИ БЕЛАРУСЬ

    УЧРЕЖДЕНИЕ ОБРАЗОВАНИЯ\
    ГОМЕЛЬСКИЙ ГОСУДАРСТВЕННЫЙ ТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ ИМЕНИ П. О. СУХОГО
    
    Факультет автоматизированных и информационных систем


    Кафедра "Информационные технологии"

    \

    #set par(spacing: 0.5em)

    *дисциплина: "#course"*

    \

    *ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ №#number*

    *"#theme"*

    *Вариант №#variant*
    
    #set par(spacing: 0.5em)


  ]

  v(18em)

  align(left)[
    #set par(justify: true, first-line-indent: (amount: 6.0cm, all: true))

    *Выполнил: студент гр. #group #student*
    
    *Принял: #supervisorTitle #supervisor*
  ]

  v(1fr)

  align(center)[
    Гомель #year
  ]

  pagebreak()
}
