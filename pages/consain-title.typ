// Стиль оформления титульного листа для концепт-, дизайн-документов.

#let _to-image(pic, height) = {
  if type(pic) == content {
    pic
  } else {
    image(pic, height: height) // str | path | bytes
  }
}

#let page(
  conceptName: "Last Descent",
  type: "Концепт",
  picturePath: none,
  pictureHeight: 200pt,
  course: "ооп",
  theme: "программирование",
  group: "ИТП-21",
  student: "Лосев М.А.",
  supervisor: "Карась О.В.",
  supervisorTitle: "ассистент",
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
  ]

  v(1fr)

  align(center)[

    // Показ картинки: путь (str/path) либо готовый элемент image(...).
    // Высота ограничивается pictureHeight, ширина — пропорционально.
    #if picturePath != none [
      #set image(height: pictureHeight)
      #_to-image(picturePath, pictureHeight)
    ]

    #set text(size: 36pt)

    *#conceptName*

    #set text(size: 14pt)
    #set par(spacing: 24pt)
    
    #set par(spacing: 0.5em)

    #type\-документ

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

  align(center)[
    Гомель #year
  ]

  pagebreak()
}
