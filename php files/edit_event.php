<?php
include 'dbconnection.php';

$con = dbconnection();

// Assuming POST data contains event details and event ID
$eventId = $_POST['id'];
$name = $_POST['name'];
$date = $_POST['date'];
$time = $_POST['time'];
$location = $_POST['location'];
$description = $_POST['description'];

// SQL UPDATE query
$sql = "UPDATE events SET 
        name = '$name',
        date = '$date',
        time = '$time',
        location = '$location',
        description = '$description'
        WHERE id = $eventId";

if (mysqli_query($con, $sql)) {
    echo json_encode(array("message" => "Event updated successfully"));
} else {
    echo json_encode(array("error" => mysqli_error($con)));
}

mysqli_close($con);
?>
