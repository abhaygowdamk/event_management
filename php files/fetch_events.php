<?php
include 'dbconnection.php';

$con = dbconnection();

$sql = "SELECT * FROM events";
$result = mysqli_query($con, $sql);

$events = array();

while($row = mysqli_fetch_assoc($result)) {
    $events[] = $row;
}

mysqli_close($con);

echo json_encode($events);
?>
