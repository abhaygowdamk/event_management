<?php
include 'dbconnection.php'; // Include the file that contains the dbconnection function

$con = dbconnection();

$sql = "SELECT * FROM events";
$result = mysqli_query($con, $sql);

if (mysqli_num_rows($result) > 0) {
    $events = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $events[] = $row;
    }
    echo json_encode(['status' => 'success', 'events' => $events]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No events found']);
}

mysqli_close($con);
?>
