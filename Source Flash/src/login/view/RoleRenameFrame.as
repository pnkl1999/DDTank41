package login.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.Role;
   import ddt.data.analyze.LoginRenameAnalyzer;
   import ddt.data.analyze.ReworkNameAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.net.URLVariables;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class RoleRenameFrame extends Frame
   {
      
      protected static var w:String = "abcdefghijklmnopqrstuvwxyz";
      
      protected static const Aviable:String = "aviable";
      
      protected static const UnAviable:String = "unaviable";
      
      protected static const Input:String = "input";
       
      
      private var _nicknameBack:Bitmap;
      
      protected var _nicknameField:FilterFrameText;
      
      protected var _nicknameLabel:FilterFrameText;
      
      protected var _modifyButton:BaseButton;
      
      protected var _resultString:String;
      
      protected var _resultField:FilterFrameText;
      
      protected var _disenabelFilter:ColorMatrixFilter;
      
      protected var _tempPass:String;
      
      protected var _roleInfo:Role;
      
      protected var _path:String = "RenameNick.ashx";
      
      protected var _checkPath:String = "NickNameCheck.ashx";
      
      protected var _complete:Boolean = false;
      
      protected var _isCanRework:Boolean = false;
      
      protected var _state:String;
      
      protected var _newName:String;
      
      public function RoleRenameFrame()
      {
         this._resultString = LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.check_txt");
         super();
         this.configUi();
         this.addEvent();
      }
      
      protected function configUi() : void
      {
         this._disenabelFilter = ComponentFactory.Instance.model.getSet("login.ChooseRole.DisenableGF");
         titleStyle = "login.Title";
         titleText = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
         this._nicknameBack = ComponentFactory.Instance.creatBitmap("login.Rename.NicknameBackground");
         addToContent(this._nicknameBack);
         this._nicknameLabel = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameLabel");
         this._nicknameLabel.text = LanguageMgr.GetTranslation("tank.loginstate.characterModify");
         addToContent(this._nicknameLabel);
         this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.NicknameInput");
         addToContent(this._nicknameField);
         this._resultField = ComponentFactory.Instance.creatComponentByStylename("login.Rename.RenameResult");
         addToContent(this._resultField);
         this._modifyButton = ComponentFactory.Instance.creatComponentByStylename("login.Rename.ModifyButton");
         addToContent(this._modifyButton);
         this._modifyButton.enable = false;
         this._modifyButton.filters = [this._disenabelFilter];
         this.state = Input;
      }
      
      private function addEvent() : void
      {
         this._modifyButton.addEventListener(MouseEvent.CLICK,this.__onModifyClick);
         this._nicknameField.addEventListener(Event.CHANGE,this.__onTextChange);
      }
      
      private function removeEvent() : void
      {
         if(this._modifyButton)
         {
            this._modifyButton.removeEventListener(MouseEvent.CLICK,this.__onModifyClick);
         }
         if(this._nicknameField)
         {
            this._nicknameField.removeEventListener(Event.CHANGE,this.__onTextChange);
         }
      }
      
      private function __onTextChange(param1:Event) : void
      {
         this.state = Input;
         if(this._nicknameField.text == "" || !this._nicknameField.text)
         {
            if(this._modifyButton.enable)
            {
               this._modifyButton.enable = false;
               this._modifyButton.filters = [this._disenabelFilter];
            }
         }
         else if(!this._modifyButton.enable)
         {
            this._modifyButton.enable = true;
            this._modifyButton.filters = null;
         }
      }
      
      protected function __onModifyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._modifyButton.enable)
         {
            this._modifyButton.enable = false;
            this._modifyButton.filters = [this._disenabelFilter];
         }
         this._newName = this._nicknameField.text;
         var _loc2_:BaseLoader = this.createCheckLoader(this._checkPath,this.checkCallBack);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      protected function createCheckLoader(param1:String, param2:Function) : BaseLoader
      {
         var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc3_["id"] = PlayerManager.Instance.Self.ID;
         _loc3_["NickName"] = this._newName;
         var _loc4_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(param1),BaseLoader.REQUEST_LOADER,_loc3_);
         _loc4_.analyzer = new ReworkNameAnalyzer(param2);
         _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc4_);
         return _loc4_;
      }
      
      protected function createModifyLoader(param1:String, param2:URLVariables, param3:String, param4:Function) : RequestLoader
      {
         var _loc5_:RequestLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(param1),BaseLoader.REQUEST_LOADER,param2);
         _loc5_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadLoginError);
         var _loc6_:LoginRenameAnalyzer = new LoginRenameAnalyzer(param4);
         _loc6_.tempPassword = param3;
         _loc5_.analyzer = _loc6_;
         return _loc5_;
      }
      
      private function __onLoadLoginError(param1:LoaderEvent) : void
      {
      }
      
      protected function checkCallBack(param1:ReworkNameAnalyzer) : void
      {
         var _loc2_:XML = param1.result;
         if(_loc2_.@value == "true")
         {
            this.state = Aviable;
            this._resultField.text = _loc2_.@message;
            this.doRename();
         }
         else
         {
            this._resultField.text = _loc2_.@message;
            this.state = UnAviable;
         }
      }
      
      protected function renameCallBack(param1:LoginRenameAnalyzer) : void
      {
         var _loc2_:XML = param1.result;
         if(_loc2_.@value == "true")
         {
            this.state = Aviable;
            this.renameComplete();
         }
         else
         {
            this._resultField.text = _loc2_.@message;
            this.state = UnAviable;
         }
      }
      
      protected function doRename() : void
      {
         if(this._modifyButton.enable)
         {
            this._modifyButton.enable = false;
            this._modifyButton.filters = [this._disenabelFilter];
         }
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
         _loc3_.writeUTFBytes(_loc1_.Account + "," + _loc1_.Password + "," + _loc4_ + "," + this._roleInfo.NickName + "," + this._newName);
         var _loc6_:String = CrytoUtils.rsaEncry4(_loc1_.Key,_loc3_);
         var _loc7_:URLVariables = RequestVairableCreater.creatWidthKey(false);
         _loc7_["p"] = _loc6_;
         _loc7_["v"] = Version.Build;
         _loc7_["site"] = PathManager.solveConfigSite();
         var _loc8_:RequestLoader = this.createModifyLoader(this._path,_loc7_,_loc4_,this.renameCallBack);
         LoaderManager.Instance.startLoad(_loc8_);
      }
      
      protected function renameComplete() : void
      {
         if(!this._modifyButton.enable)
         {
            this._modifyButton.enable = true;
            this._modifyButton.filters = null;
         }
         this._roleInfo.NameChanged = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      public function get roleInfo() : Role
      {
         return this._roleInfo;
      }
      
      public function set roleInfo(param1:Role) : void
      {
         this._roleInfo = param1;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         if(this._state != param1)
         {
            this._state = param1;
            if(this._state == Aviable)
            {
               _loc2_ = ComponentFactory.Instance.model.getSet("login.Rename.ResultAvailableTF");
               this._resultField.defaultTextFormat = _loc2_;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(_loc2_,0,this._resultField.length);
               }
            }
            else if(this._state == UnAviable)
            {
               if(this._modifyButton.enable)
               {
                  this._modifyButton.enable = false;
                  this._modifyButton.filters = [this._disenabelFilter];
               }
               _loc2_ = ComponentFactory.Instance.model.getSet("login.Rename.ResultUnAvailableTF");
               this._resultField.defaultTextFormat = _loc2_;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(_loc2_,0,this._resultField.length);
               }
            }
            else
            {
               this._resultField.text = this._resultString;
               _loc2_ = ComponentFactory.Instance.model.getSet("login.Rename.ResultDefaultTF");
               this._resultField.defaultTextFormat = _loc2_;
               if(this._resultField.length > 0)
               {
                  this._resultField.setTextFormat(_loc2_,0,this._resultField.length);
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this._nicknameBack)
         {
            ObjectUtils.disposeObject(this._nicknameBack);
            this._nicknameBack = null;
         }
         if(this._nicknameLabel)
         {
            ObjectUtils.disposeObject(this._nicknameLabel);
            this._nicknameLabel = null;
         }
         if(this._nicknameField)
         {
            ObjectUtils.disposeObject(this._nicknameField);
            this._nicknameField = null;
         }
         if(this._modifyButton)
         {
            ObjectUtils.disposeObject(this._modifyButton);
            this._modifyButton = null;
         }
         this._roleInfo = null;
         super.dispose();
      }
   }
}
