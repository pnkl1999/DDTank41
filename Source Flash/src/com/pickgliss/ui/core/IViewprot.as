package com.pickgliss.ui.core
{
   import com.pickgliss.geom.IntDimension;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.geom.IntRectangle;
   import flash.display.IDisplayObject;
   
   [Event(name="stateChanged",type="org.aswing.event.InteractiveEvent")]
   public interface IViewprot extends IDisplayObject
   {
       
      
      function get verticalUnitIncrement() : int;
      
      function get verticalBlockIncrement() : int;
      
      function get horizontalUnitIncrement() : int;
      
      function get horizontalBlockIncrement() : int;
      
      function set verticalUnitIncrement(param1:int) : void;
      
      function set verticalBlockIncrement(param1:int) : void;
      
      function set horizontalUnitIncrement(param1:int) : void;
      
      function set horizontalBlockIncrement(param1:int) : void;
      
      function setViewportTestSize(param1:IntDimension) : void;
      
      function getExtentSize() : IntDimension;
      
      function getViewSize() : IntDimension;
      
      function get viewPosition() : IntPoint;
      
      function set viewPosition(param1:IntPoint) : void;
      
      function scrollRectToVisible(param1:IntRectangle) : void;
      
      function addStateListener(param1:Function, param2:int = 0, param3:Boolean = false) : void;
      
      function removeStateListener(param1:Function) : void;
      
      function getViewportPane() : Component;
   }
}
