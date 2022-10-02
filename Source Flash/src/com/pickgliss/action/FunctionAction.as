package com.pickgliss.action
{
   public class FunctionAction extends BaseAction
   {
       
      
      private var _fun:Function;
      
      public function FunctionAction(param1:Function)
      {
         super();
         this._fun = param1;
      }
      
      override public function act() : void
      {
         this._fun();
      }
   }
}
