<?php
include 'dbconnection.php'; // Include the file that contains the dbconnection function

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();

    $name = $_POST['name'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $location = $_POST['location'];
    $description = $_POST['description'];
    $price = $_POST['price']; // Get the price from the POST request

    $sql = "INSERT INTO events (name, date, time, location, description, price) VALUES ('$name', '$date', '$time', '$location', '$description', '$price')";

    if (mysqli_query($con, $sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Event created successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error: ' . mysqli_error($con)]);
    }

    mysqli_close($con);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
