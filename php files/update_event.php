<?php
include 'dbconnection.php';

$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $location = $_POST['location'];
    $description = $_POST['description'];

    $sql = "UPDATE events SET name='$name', date='$date', time='$time', location='$location', description='$description' WHERE id=$id";
    if (mysqli_query($con, $sql)) {
        echo "Event updated successfully";
    } else {
        echo "Error updating event: " . mysqli_error($con);
    }
} else {
    echo "Invalid request method";
}

mysqli_close($con);
?>
