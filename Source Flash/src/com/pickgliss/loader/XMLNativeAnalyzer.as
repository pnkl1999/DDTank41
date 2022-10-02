package com.pickgliss.loader
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class XMLNativeAnalyzer extends DataAnalyzer
   {
       
      
      public function XMLNativeAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         ComponentFactory.Instance.setup(_loc2_);
         onAnalyzeComplete();
      }
   }
}
