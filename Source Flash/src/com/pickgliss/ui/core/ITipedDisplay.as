package com.pickgliss.ui.core
{
   import flash.display.IDisplayObject;
   
   public interface ITipedDisplay extends IDisplayObject
   {
       
      
      function get tipData() : Object;
      
      function set tipData(param1:Object) : void;
      
      function get tipDirctions() : String;
      
      function set tipDirctions(param1:String) : void;
      
      function get tipGapH() : int;
      
      function set tipGapH(param1:int) : void;
      
      function get tipGapV() : int;
      
      function set tipGapV(param1:int) : void;
      
      function get tipStyle() : String;
      
      function set tipStyle(param1:String) : void;
   }
}
