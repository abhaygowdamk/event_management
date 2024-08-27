<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();
    $username = $_POST['username'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $password = $_POST['password'];

    $query = "INSERT INTO users (uname, uemail, uphone, upassword) VALUES ('$username', '$email', '$phone', '$password')";
    if (mysqli_query($con, $query)) {
        echo json_encode(["status" => "success", "message" => "Registration successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Registration failed"]);
    }

    mysqli_close($con);
}
?>
