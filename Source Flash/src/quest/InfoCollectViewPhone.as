package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.LanguageMgr;
   import flash.net.URLVariables;
   
   public class InfoCollectViewPhone extends InfoCollectView
   {
       
      
      public function InfoCollectViewPhone()
      {
         super();
         Type = 2;
      }
      
      override protected function addLabel() : void
      {
         _dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         _dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phone");
      }
      
      override protected function fillArgs(param1:URLVariables) : URLVariables
      {
         param1["phone"] = param1["input"];
         return param1;
      }
      
      override protected function updateHelper(param1:String) : String
      {
         return "";
      }
   }
}
