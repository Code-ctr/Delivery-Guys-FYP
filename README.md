# Delivery Guys fyp

Delivery Guys is a Flutter-based pickup and delivery app built to handle the complete process of ordering, delivery, and management. The app is connected with Firebase for real-time data storage, authentication, and notifications. It is designed for three roles: customers, drivers, and admins.

On the customer side, users can browse products, add them to the cart, and place orders. Customers receive real-time updates on their orders, from acceptance to delivery, through Firebase Cloud Messaging. After a delivery is completed, customers can give ratings and feedback. They can also view their order history and feedback history.

On the driver side, drivers receive new order requests which they can accept or reject. They can view assigned orders, update the delivery status step by step, and send real-time updates to customers. The app also allows drivers to track their past deliveries. A real-time map integration shows the driver’s location during delivery, helping customers and admins track orders.

The admin side includes features to manage users, customers, and drivers. Admins can activate or deactivate accounts, manage items and their stock levels, and generate reports like sales reports and expenses per store. This makes the app not only a delivery solution but also a small business management tool.

The app uses Flutter and Dart on the frontend, Firebase Firestore as the database, Firebase Authentication for login and registration, and Firebase Cloud Messaging for push notifications. Google Maps API is integrated to handle real-time driver location tracking.

Overall, Delivery Guys is a complete solution for businesses that need a system to manage deliveries, track drivers, keep customers updated, and maintain business records in one app.
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
