package com.pickgliss.action
{
   public interface IAction
   {
       
      
      function act() : void;
      
      function setCompleteFun(param1:Function) : void;
      
      function get acting() : Boolean;
      
      function cancel() : void;
   }
}
