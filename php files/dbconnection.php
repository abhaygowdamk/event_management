<?php
function dbconnection()
{
    $con = mysqli_connect("localhost", "root", "", "fest_management");
    return $con;
}
?>