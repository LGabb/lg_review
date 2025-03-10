/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPIData class
 */

@IsTest
public with sharing class OCAPIDataTest {

    @TestSetup
    public static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();
    }

    @IsTest
    public static void testOCAPIData(){
        OCAPIData ocapi = new OCAPIData();
    }

}