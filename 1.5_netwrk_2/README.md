# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
![Alt text](img/image.png)

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 

![Alt text](img/image-1.png)

4. Продемонстрировать, что приложения видят друг друга с помощью Service.
   
![Alt text](img/image-2.png)

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

[Manifest_front+service](dep_task1_front.yaml)

[Manifest_back+service](dep_task1_back.yaml)

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.  

![Alt text](img/image-3.png)

2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.

![Alt text](img/image-4.png)

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.  

![Alt text](img/image-5.png)

4. Предоставить манифесты и скриншоты или вывод команды п.2.

[ingress manifest](deployment_task2.yaml)