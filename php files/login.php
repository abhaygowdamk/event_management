<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();
    $username = $_POST['username'];
    $password = $_POST['password'];

    $query = "SELECT * FROM users WHERE uname='$username' AND upassword='$password'";
    $result = mysqli_query($con, $query);

    if (mysqli_num_rows($result) > 0) {
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid username or password"]);
    }

    mysqli_close($con);
}
?>
