package worldboss.player
{
   public class RankingPersonInfo
   {
       
      
      private var _id:int;
      
      private var _name:String;
      
      private var _damage:int;
      
      public function RankingPersonInfo()
      {
         super();
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set damage(param1:int) : void
      {
         this._damage = param1;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
   }
}
