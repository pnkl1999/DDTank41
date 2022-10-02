package store.equipGhost.data
{
   public class GhostPropertyData
   {
       
      
      private var _mainProperty:uint;
      
      private var _attack:uint;
      
      private var _lucky:uint;
      
      private var _defend:uint;
      
      private var _agility:uint;
      
      public function GhostPropertyData(param1:uint, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:uint = 0)
      {
         super();
         this._mainProperty = param1;
         this._attack = param2;
         this._lucky = param3;
         this._defend = param4;
         this._agility = param5;
      }
      
      public function get mainProperty() : uint
      {
         return this._mainProperty;
      }
      
      public function get attack() : uint
      {
         return this._attack;
      }
      
      public function get lucky() : uint
      {
         return this._lucky;
      }
      
      public function get defend() : uint
      {
         return this._defend;
      }
      
      public function get agility() : uint
      {
         return this._agility;
      }
   }
}
