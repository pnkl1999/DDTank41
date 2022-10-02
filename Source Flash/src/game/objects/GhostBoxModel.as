package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class GhostBoxModel
   {
      
      private static var _ins:GhostBoxModel;
       
      
      private var _psychicArr:Array;
      
      public function GhostBoxModel()
      {
         super();
      }
      
      public static function getInstance() : GhostBoxModel
      {
         if(_ins == null)
         {
            _ins = ComponentFactory.Instance.creatCustomObject("GhostBoxModel");
         }
         return _ins;
      }
      
      public function set psychics(param1:String) : void
      {
         this._psychicArr = param1.split(",");
      }
      
      public function getPsychicByType(param1:int) : int
      {
         if(this._psychicArr == null || param1 - 2 > this._psychicArr.length || param1 - 2 < 0)
         {
            return 0;
         }
         return this._psychicArr[param1 - 2];
      }
   }
}
