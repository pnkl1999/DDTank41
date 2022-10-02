package com.pickgliss.loader
{
   public class DataAnalyzer
   {
       
      
      protected var _onCompleteCall:Function;
      
      public var message:String;
      
      public var analyzeCompleteCall:Function;
      
      public var analyzeErrorCall:Function;
      
      public function DataAnalyzer(param1:Function)
      {
         super();
         this._onCompleteCall = param1;
      }
      
      public function analyze(param1:*) : void
      {
      }
      
      protected function onAnalyzeComplete() : void
      {
         if(this._onCompleteCall != null)
         {
            this._onCompleteCall(this);
         }
         if(this.analyzeCompleteCall != null)
         {
            this.analyzeCompleteCall();
         }
         this._onCompleteCall = null;
         this.analyzeCompleteCall = null;
      }
      
      protected function onAnalyzeError() : void
      {
         if(this.analyzeErrorCall != null)
         {
            this.analyzeErrorCall();
         }
      }
   }
}
