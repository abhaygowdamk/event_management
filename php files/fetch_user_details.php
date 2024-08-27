<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();
    $userId = $_POST['user_id'];

    $query = "SELECT * FROM users WHERE id = '$userId'";
    $result = mysqli_query($con, $query);

    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);
        echo json_encode(["status" => "success", "user" => $user]);
    } else {
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }

    mysqli_close($con);
}
?>
