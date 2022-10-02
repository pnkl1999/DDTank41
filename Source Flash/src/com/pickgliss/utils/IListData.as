package com.pickgliss.utils
{
   public interface IListData
   {
       
      
      function get(param1:int) : *;
      
      function append(param1:*, param2:int = -1) : void;
      
      function appendAll(param1:Array, param2:int = -1) : void;
      
      function appendList(param1:IListData, param2:int = -1) : void;
      
      function replaceAt(param1:int, param2:*) : *;
      
      function removeAt(param1:int) : *;
      
      function remove(param1:*) : *;
      
      function removeRange(param1:int, param2:int) : Array;
      
      function indexOf(param1:*) : int;
      
      function contains(param1:*) : Boolean;
      
      function first() : *;
      
      function last() : *;
      
      function pop() : *;
      
      function shift() : *;
      
      function size() : int;
      
      function clear() : void;
      
      function isEmpty() : Boolean;
      
      function toArray() : Array;
   }
}
