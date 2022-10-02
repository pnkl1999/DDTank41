package com.pickgliss.action
{
   public class OrderQueueAction extends BaseAction
   {
       
      
      protected var _actList:Array;
      
      protected var _count:int;
      
      public function OrderQueueAction(param1:Array, param2:uint = 0)
      {
         this._actList = param1;
         super(param2);
      }
      
      override public function act() : void
      {
         this.cancel();
         this.startAct();
         super.act();
      }
      
      private function startAct() : void
      {
         this._count = 0;
         if(this._actList.length > 0)
         {
            this.actOne();
         }
      }
      
      protected function actOne() : void
      {
         var _loc1_:IAction = this._actList[this._count] as IAction;
         _loc1_.setCompleteFun(this.actOneComplete);
         _loc1_.act();
      }
      
      private function actOneComplete(param1:IAction) : void
      {
         this.actNext();
      }
      
      protected function actNext() : void
      {
         ++this._count;
         if(this._count < this._actList.length)
         {
            this.actOne();
         }
         else
         {
            execComplete();
         }
      }
      
      override public function cancel() : void
      {
         var _loc1_:IAction = null;
         if(_acting)
         {
            _loc1_ = this._actList[this._count] as IAction;
            if(_loc1_)
            {
               _loc1_.setCompleteFun(null);
               _loc1_.cancel();
            }
         }
         super.cancel();
      }
      
      public function getActions() : Array
      {
         return this._actList;
      }
   }
}
