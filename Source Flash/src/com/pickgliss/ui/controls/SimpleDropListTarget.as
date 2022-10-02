package com.pickgliss.ui.controls
{
   import com.pickgliss.ui.controls.list.IDropListTarget;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.DisplayObject;
   
   public class SimpleDropListTarget extends FilterFrameText implements IDropListTarget
   {
       
      
      public function SimpleDropListTarget()
      {
         super();
      }
      
      public function setValue(param1:*) : void
      {
         text = String(param1);
      }
      
      public function setCursor(param1:int) : void
      {
         setSelection(param1,param1);
      }
      
      public function getValueLength() : int
      {
         return text.length;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
