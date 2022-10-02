package fightLib.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FightLibAlertView extends Sprite implements Disposeable
   {
      
      private static const ButtonToCenter:int = 8;
       
      
      private var _background:DisplayObject;
      
      private var _girlImage:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _infoStr:String;
      
      private var _okLabel:String;
      
      private var _okBtn:TextButton;
      
      private var _okFun:Function;
      
      private var _cancelLabel:String;
      
      private var _cancelBtn:TextButton;
      
      private var _cancelFun:Function;
      
      private var _showOkBtn:Boolean;
      
      private var _showCancelBtn:Boolean;
      
      private var _centerPosition:Point;
      
      private var _WeaponCellArr:Array;
      
      public function FightLibAlertView(param1:String, param2:String = null, param3:Function = null, param4:String = null, param5:Function = null, param6:Boolean = true, param7:Boolean = false, param8:Array = null)
      {
         this._okLabel = LanguageMgr.GetTranslation("ok");
         this._cancelLabel = LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain");
         super();
         this._infoStr = param1;
         if(param2)
         {
            this._okLabel = param2;
         }
         this._okFun = param3;
         if(param4)
         {
            this._cancelLabel = param4;
         }
         this._cancelFun = param5;
         this._showOkBtn = param6;
         this._showCancelBtn = param7;
         this.configUI();
         this.addEvent();
         if(!this._showCancelBtn)
         {
            this._okBtn.x = this._centerPosition.x - this._okBtn.width / 2;
         }
         else
         {
            this._okBtn.x = this._centerPosition.x - this._okBtn.width - ButtonToCenter;
            this._cancelBtn.x = this._centerPosition.x + ButtonToCenter;
         }
         this._okBtn.y = this._cancelBtn.y = this._centerPosition.y;
         this._okBtn.visible = this._showOkBtn;
         this._cancelBtn.visible = this._showCancelBtn;
         if(param8 != null)
         {
            this.ShowWeaponIcon(param8);
         }
      }
      
      private function ShowWeaponIcon(param1:Array) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc4_:int = 0;
         var _loc6_:BaseCell = null;
         var _loc8_:FilterFrameText = null;
         _loc2_ = null;
         _loc4_ = 0;
         var _loc5_:Sprite = null;
         _loc6_ = null;
         var _loc7_:String = null;
         _loc8_ = null;
         this._WeaponCellArr = new Array();
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(16777215,0);
            _loc5_.graphics.drawRect(0,0,60,60);
            _loc5_.graphics.endFill();
            _loc2_ = ItemManager.Instance.getTemplateById(param1[_loc4_]);
            _loc6_ = new BaseCell(_loc5_,_loc2_,true,false);
            _loc6_.x = 30 + _loc4_ * 70;
            _loc6_.y = 59;
            addChild(_loc6_);
            this._WeaponCellArr.push(_loc6_);
            _loc7_ = _loc2_.Name.slice(2);
            _loc8_ = ComponentFactory.Instance.creatComponentByStylename("fightLib.WeaponNameField");
            _loc8_.x = 39 + _loc4_ * 70;
            _loc8_.y = 107;
            _loc8_.text = _loc7_;
            addChild(_loc8_);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         if(this._WeaponCellArr != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._WeaponCellArr.length)
            {
               this._WeaponCellArr[_loc1_].dispose();
               _loc1_++;
            }
         }
         ObjectUtils.disposeAllChildren(this);
         this._background = null;
         this._girlImage = null;
         this._cancelBtn = null;
         this._cancelFun = null;
         this._okBtn = null;
         this._okFun = null;
         this._txt = null;
         this._WeaponCellArr = null;
      }
      
      public function show() : void
      {
         x = StageReferance.stageWidth - width >> 1;
         y = StageReferance.stageHeight - height >> 1;
         this._txt.text = this._infoStr;
         this.updataWeaponIcon();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER);
      }
      
      private function updataWeaponIcon() : void
      {
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set alert(param1:String) : void
      {
         this._txt.text = param1;
      }
      
      public function get alert() : String
      {
         return this._txt.text;
      }
      
      private function configUI() : void
      {
         this._centerPosition = ComponentFactory.Instance.creatCustomObject("fithtLib.Alert.CenterPosition");
         this._background = ComponentFactory.Instance.creatComponentByStylename("fightLib.Game.GirlGuildBack");
         addChild(this._background);
         this._girlImage = ComponentFactory.Instance.creatBitmap("fightLib.Game.GirlGuild.Girl");
         this._girlImage.scaleX = -0.6;
         this._girlImage.scaleY = 0.6;
         addChild(this._girlImage);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.AlertField");
         addChild(this._txt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.SubmitButton");
         if(this._okLabel != null)
         {
            this._okBtn.text = this._okLabel;
         }
         else
         {
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
         }
         addChild(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("fightLib.Alert.CancelButton");
         if(this._cancelLabel != null)
         {
            this._cancelBtn.text = this._cancelLabel;
         }
         else
         {
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         }
         addChild(this._cancelBtn);
      }
      
      private function addEvent() : void
      {
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__submitClicked);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClicked);
      }
      
      private function __cancelClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._cancelFun != null)
         {
            this._cancelFun();
         }
      }
      
      private function __submitClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._okFun != null)
         {
            this._okFun();
         }
      }
      
      private function removeEvent() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__submitClicked);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClicked);
      }
   }
}
