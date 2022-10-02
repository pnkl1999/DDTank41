package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   
   public class InfoCollectViewMail extends InfoCollectView
   {
       
      
      private const DomainArray:Array = ["163.com","qq.com"];
      
      public function InfoCollectViewMail()
      {
         super();
         Type = 1;
      }
      
      override protected function fillArgs(param1:URLVariables) : URLVariables
      {
         param1["mail"] = param1["input"];
         return param1;
      }
      
      override protected function modifyView() : void
      {
         _inputData.maxChars = 50;
      }
      
      override protected function addLabel() : void
      {
         _dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         _dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.email");
      }
      
      override protected function updateHelper(param1:String) : String
      {
         if(param1 == "")
         {
            return "";
         }
         if(param1.indexOf("@") < 0)
         {
            return "ddt.quest.collectInfo.notValidMailAddress";
         }
         var _loc2_:String = param1.substr(param1.indexOf("@") + 1);
         if(_loc2_.indexOf(".") < 0)
         {
            return "ddt.quest.collectInfo.notValidMailAddress";
         }
         return "ddt.quest.collectInfo.validMailAddress";
      }
      
      private function cansearch(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.DomainArray)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function __onSendBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(_inputData.text.length < 1)
         {
            alert("ddt.quest.collectInfo.noMail");
            return;
         }
         sendData();
      }
   }
}
