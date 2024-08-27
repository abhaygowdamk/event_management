<?php
include 'dbconnection.php';

$con = dbconnection();

// Assuming POST data contains event ID
$eventId = $_POST['id'];

// SQL DELETE query
$sql = "DELETE FROM events WHERE id = $eventId";

if (mysqli_query($con, $sql)) {
    echo json_encode(array("message" => "Event deleted successfully"));
} else {
    echo json_encode(array("error" => mysqli_error($con)));
}

mysqli_close($con);
?>