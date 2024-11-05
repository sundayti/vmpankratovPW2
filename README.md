# Ответы на вопросы дз2
## What issues prevent us from using storyboards in real projects?
Storyboard ограничивае возможности переиспользования кода, что критично для крупных проектов. 
## What does the code on lines 25 and 29 do?
- На строке 25-й устанавливается translatesAutoresizingMaskIntoConstraints = false, чтобы отключить автоматические ограничения объекта, чтобы можно было задавать его расположения с помощью NSLayoutConstraints.
- На 29-й строке title но ViewControler, чтобы title отображался на экране, а также, чтобы можно было настроить NSLayoutConstraints.
## What is a safe area layout guide?
Safe Area Layout Guide это безопасная зона экрана, внутри которой контент не будет перекрыт системными элементами интерфейса (например dynamic island).
## What is [weak self] on line 23 and why it is important?
[weak self] предотвращает захват сильной ссылки на self в closure, чтобы избежать циклических ссылок, которые могут привести к утечке памяти.
## What does clipsToBounds mean?
clipsToBounds обрезает все subviews, которые выходят за границы основного представления. Если свойство установлено в true, все элементы, которые выходят за границы родительского view, не будут отображаться.
## What is the valueChanged type? What is Void and what is Double?
valueChanged — это clouser с типом (Double) -> Void. Double — тип данных, передаваемый в clouser, а Void означает, что clouser не возвращает значения.
