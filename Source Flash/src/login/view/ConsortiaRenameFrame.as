package login.view
{
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class ConsortiaRenameFrame extends RoleRenameFrame
   {
       
      
      public function ConsortiaRenameFrame()
      {
         super();
         _path = "RenameConsortiaName.ashx";
         _checkPath = "ConsortiaNameCheck.ashx";
         _resultString = LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert");
         _resultField.text = _resultString;
      }
      
      override protected function configUi() : void
      {
         super.configUi();
         titleText = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
         _nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.guildNameModify");
         if(_nicknameField)
         {
            _nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ConsortianameInput");
            addToContent(_nicknameField);
         }
      }
      
      override protected function __onModifyClick(param1:MouseEvent) : void
      {
         super.__onModifyClick(param1);
      }
      
      override protected function doRename() : void
      {
         var _loc1_:AccountInfo = PlayerManager.Instance.Account;
         var _loc2_:Date = new Date();
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeShort(_loc2_.fullYearUTC);
         _loc3_.writeByte(_loc2_.monthUTC + 1);
         _loc3_.writeByte(_loc2_.dateUTC);
         _loc3_.writeByte(_loc2_.hoursUTC);
         _loc3_.writeByte(_loc2_.minutesUTC);
         _loc3_.writeByte(_loc2_.secondsUTC);
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < 6)
         {
            _loc4_ += w.charAt(int(Math.random() * 26));
            _loc5_++;
         }
         _loc3_.writeUTFBytes(_loc1_.Account + "," + _loc1_.Password + "," + _loc4_ + "," + _roleInfo.NickName + "," + _newName);
         var _loc6_:String = CrytoUtils.rsaEncry4(_loc1_.Key,_loc3_);
         var _loc7_:URLVariables = RequestVairableCreater.creatWidthKey(false);
         _loc7_["p"] = _loc6_;
         _loc7_["v"] = Version.Build;
         _loc7_["site"] = PathManager.solveConfigSite();
         var _loc8_:RequestLoader = this.createModifyLoader(_path,_loc7_,_loc4_,renameCallBack);
         LoaderManager.Instance.startLoad(_loc8_);
      }
      
      override protected function createModifyLoader(param1:String, param2:URLVariables, param3:String, param4:Function) : RequestLoader
      {
         return super.createModifyLoader(param1,param2,param3,param4);
      }
      
      override protected function renameComplete() : void
      {
         _roleInfo.ConsortiaNameChanged = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
