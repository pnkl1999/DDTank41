package store.equipGhost.data
{
   public final class GhostData
   {
       
      
      private var _level:int;
      
      private var _mustGetTimes:int;
      
      private var _baseSuccessPro:int;
      
      private var _refrenceValue:int;
      
      private var _skillId:int;
      
      private var _attackAdd:int;
      
      private var _luckAdd:int;
      
      private var _defendAdd:int;
      
      private var _agilityAdd:int;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _categoryid:int;
      
      public function GhostData()
      {
         super();
      }
      
      public function get skillId() : int
      {
         return this._skillId;
      }
      
      public function get categoryID() : int
      {
         return this._categoryid;
      }
      
      public function get agilityAdd() : int
      {
         return this._agilityAdd;
      }
      
      public function get defendAdd() : int
      {
         return this._defendAdd;
      }
      
      public function get luckAdd() : int
      {
         return this._luckAdd;
      }
      
      public function get attackAdd() : int
      {
         return this._attackAdd;
      }
      
      public function get refrenceValue() : int
      {
         return this._refrenceValue;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function parseXML(param1:XML) : void
      {
         this._level = parseInt(param1.@Level);
         this._mustGetTimes = parseInt(param1.@MustGetTimes);
         this._baseSuccessPro = parseInt(param1.@BaseSuccessPro);
         this._refrenceValue = parseInt(param1.@RefrenceValue);
         this._skillId = parseInt(param1.@SkillId);
         this._attackAdd = parseInt(param1.@AttackAdd);
         this._luckAdd = parseInt(param1.@LuckAdd);
         this._defendAdd = parseInt(param1.@DefendAdd);
         this._agilityAdd = parseInt(param1.@AgilityAdd);
         this._bagType = parseInt(param1.@BagType);
         this._place = parseInt(param1.@BagPlace);
         this._categoryid = parseInt(param1.@CategoryId);
      }
      
      public function get baseSuccessPro() : int
      {
         return this._baseSuccessPro;
      }
      
      public function get mustGetTimes() : int
      {
         return this._mustGetTimes;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
   }
}
