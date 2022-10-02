package ddt.data.fightLib
{
   public class FightLibAwardInfo
   {
       
      
      private var _id:int;
      
      private var _easyAward:Array;
      
      private var _normalAward:Array;
      
      private var _difficultAward:Array;
      
      public function FightLibAwardInfo()
      {
         super();
         this._easyAward = [];
         this._normalAward = [];
         this._difficultAward = [];
      }
      
      public function get easyAward() : Array
      {
         return this._easyAward;
      }
      
      public function set easyAward(param1:Array) : void
      {
         this._easyAward = param1;
      }
      
      public function get normalAward() : Array
      {
         return this._normalAward;
      }
      
      public function set normalAward(param1:Array) : void
      {
         this._normalAward = param1;
      }
      
      public function get difficultAward() : Array
      {
         return this._difficultAward;
      }
      
      public function set difficultAward(param1:Array) : void
      {
         this._difficultAward = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
   }
}
