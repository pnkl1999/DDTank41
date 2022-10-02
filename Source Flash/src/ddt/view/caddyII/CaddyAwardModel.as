package ddt.view.caddyII
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class CaddyAwardModel
   {
      
      private static var _ins:CaddyAwardModel;
       
      
      private var _awards:Array;
      
      private var _silverAwards:Array;
      
      private var _goldAwards:Array;
      
      public var silverAwardCount:int;
      
      public var goldAwardCount:int;
      
      public function CaddyAwardModel()
      {
         super();
      }
      
      public static function getInstance() : CaddyAwardModel
      {
         if(_ins == null)
         {
            _ins = ComponentFactory.Instance.creatCustomObject("CaddyAwardModel");
         }
         return _ins;
      }
      
      public function set awardData(param1:String) : void
      {
         this._awards = param1.split(",");
      }
      
      public function set silverAwardData(param1:String) : void
      {
         this._silverAwards = param1.split(",");
      }
      
      public function set goldAwardData(param1:String) : void
      {
         this._goldAwards = param1.split(",");
      }
      
      public function getAwards() : Array
      {
         return this._awards;
      }
      
      public function getSilverAwards() : Array
      {
         return this._silverAwards;
      }
      
      public function getGoldAwards() : Array
      {
         return this._goldAwards;
      }
   }
}
