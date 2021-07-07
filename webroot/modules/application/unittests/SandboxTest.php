<?php
/**
 * Testing playground
 */
class SandboxTest extends \PHPUnit\Framework\TestCase {

    function testSomething() {
        $array = array();
        $array["test"] = "test";
        $array["Test"] = "Test";
        $this->assertEquals($array["test"], "test");
        $this->assertEquals($array["Test"], "Test");

        $o = new stdClass();
        $o->test = "test";
        $o->Test = "Test";
        $this->assertEquals($o->test, "test");
        $this->assertEquals($o->Test, "Test");
    }

}