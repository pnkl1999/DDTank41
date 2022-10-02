package newChickenBox.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   import newChickenBox.model.NewChickenBoxModel;
   
   public class NewChickenBoxView extends Sprite implements Disposeable
   {
      
      private static const NUM:int = 18;
       
      
      private var _model:NewChickenBoxModel;
      
      private var eyeItem:NewChickenBoxItem;
      
      private var frame:BaseAlerFrame;
      
      private var moveBackArr:Array;
      
      public function NewChickenBoxView()
      {
         super();
         this._model = NewChickenBoxModel.instance;
         this.init();
      }
      
      private function init() : void
      {
         this.moveBackArr = new Array();
         if(this._model.isShowAll)
         {
            this.getAllItem();
         }
         else
         {
            this.updataAllItem();
         }
      }
      
      public function getAllItem() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:String = null;
         var _loc7_:NewChickenBoxGoodsTempInfo = null;
         var _loc8_:Sprite = null;
         var _loc9_:NewChickenBoxCell = null;
         var _loc10_:MovieClip = null;
         var _loc11_:NewChickenBoxItem = null;
         var _loc1_:int = Math.random() * 18;
         var _loc2_:int = this.getNum(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < NUM)
         {
            _loc4_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            _loc5_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            _loc6_ = "newChickenBox.itemPos" + _loc3_;
            _loc7_ = this._model.templateIDList[_loc3_];
            _loc8_ = new Sprite();
            _loc8_.graphics.beginFill(16777215,0);
            _loc8_.graphics.drawRect(0,0,39,39);
            _loc8_.graphics.endFill();
            _loc9_ = new NewChickenBoxCell(_loc8_,_loc7_.info);
            if(_loc3_ == _loc1_ || _loc3_ == _loc2_)
            {
               _loc10_ = _loc5_;
               this.moveBackArr.push(_loc3_);
            }
            else
            {
               _loc10_ = _loc4_;
            }
            _loc11_ = new NewChickenBoxItem(_loc9_,_loc10_);
            _loc11_.info = _loc7_;
            _loc11_.updateCount();
            _loc11_.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            _loc11_.position = _loc3_;
            PositionUtils.setPos(_loc11_,_loc6_);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[_loc3_].dispose();
               this._model.itemList[_loc3_] = null;
               this._model.itemList[_loc3_] = _loc11_;
            }
            else
            {
               this._model.itemList.push(_loc11_);
            }
            addChild(_loc11_);
            _loc3_++;
         }
      }
      
      private function openAlertFrame(param1:NewChickenBoxItem) : BaseAlerFrame
      {
         var _loc2_:String = LanguageMgr.GetTranslation("newChickenBox.EagleEye.msg",this._model.canEagleEyeCounts - this._model.countEye,this._model.eagleEyePrice[this._model.countEye]);
         var _loc3_:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt2");
         _loc3_.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         _loc3_.addEventListener(MouseEvent.CLICK,this.noAlertEable);
         if(this.frame)
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
         this.frame.addChild(_loc3_);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this.eyeItem = param1;
         return this.frame;
      }
      
      private function noAlertEable(param1:MouseEvent) : void
      {
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         if(_loc2_.selected)
         {
            this._model.alertEye = false;
         }
         else
         {
            this._model.alertEye = true;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendChickenBoxUseEagleEye(this.eyeItem);
         }
      }
      
      public function getItemEvent(param1:NewChickenBoxItem) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.tackoverCard);
      }
      
      public function removeItemEvent(param1:NewChickenBoxItem) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.tackoverCard);
         param1.dispose();
      }
      
      public function tackoverCard(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:NewChickenBoxItem = param1.currentTarget as NewChickenBoxItem;
         var _loc3_:NewChickenBoxGoodsTempInfo = _loc2_.info;
         if(this._model.canclickEnable && _loc3_.IsSelected == false)
         {
            if(this._model.clickEagleEye)
            {
               _loc4_ = this._model.eagleEyePrice[this._model.countEye];
               if(PlayerManager.Instance.Self.Money < _loc4_)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               if(_loc3_.IsSeeded)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.useEyeEnable"));
                  return;
               }
               if(this._model.alertEye)
               {
                  if(this._model.countEye < this._model.canEagleEyeCounts)
                  {
                     this._model.dispatchEvent(new Event("mouseShapoff"));
                     this.openAlertFrame(_loc2_);
                  }
                  else
                  {
                     SocketManager.Instance.out.sendChickenBoxUseEagleEye(_loc2_);
                  }
               }
               else
               {
                  SocketManager.Instance.out.sendChickenBoxUseEagleEye(_loc2_);
               }
            }
            else
            {
               _loc4_ = this._model.openCardPrice[this._model.countTime];
               if(PlayerManager.Instance.Self.Money < _loc4_)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.sendChickenBoxTakeOverCard(_loc2_);
            }
            this._model.clickEagleEye = false;
         }
      }
      
      private function getNum(param1:int) : int
      {
         var _loc2_:int = Math.random() * 18;
         if(_loc2_ == param1)
         {
            this.getNum(param1);
         }
         return _loc2_;
      }
      
      public function updataAllItem() : void
      {
         var _loc4_:String = null;
         var _loc5_:NewChickenBoxGoodsTempInfo = null;
         var _loc6_:Sprite = null;
         var _loc7_:NewChickenBoxCell = null;
         var _loc8_:MovieClip = null;
         var _loc9_:NewChickenBoxItem = null;
         var _loc1_:int = Math.random() * 18;
         var _loc2_:int = this.getNum(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < this._model.templateIDList.length)
         {
            _loc4_ = "newChickenBox.itemPos" + _loc3_;
            _loc5_ = this._model.templateIDList[_loc3_];
            _loc6_ = new Sprite();
            _loc6_.graphics.beginFill(16777215,0);
            _loc6_.graphics.drawRect(0,0,39,39);
            _loc6_.graphics.endFill();
            _loc7_ = new NewChickenBoxCell(_loc6_,_loc5_.info);
            if((_loc3_ == _loc1_ || _loc3_ == _loc2_) && _loc5_.IsSelected)
            {
               _loc8_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            }
            else if(_loc5_.IsSelected)
            {
               _loc8_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            }
            else if(_loc5_.IsSeeded)
            {
               _loc8_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               _loc7_.visible = true;
               _loc7_.alpha = 0.5;
            }
            else
            {
               _loc8_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               _loc7_.visible = false;
            }
            _loc9_ = new NewChickenBoxItem(_loc7_,_loc8_);
            _loc9_.info = _loc5_;
            _loc9_.updateCount();
            _loc9_.countTextShowIf();
            _loc9_.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            _loc9_.position = _loc3_;
            PositionUtils.setPos(_loc9_,_loc4_);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[_loc3_].dispose();
               this._model.itemList[_loc3_] = null;
               this._model.itemList[_loc3_] = _loc9_;
            }
            else
            {
               this._model.itemList.push(_loc9_);
            }
            addChild(_loc9_);
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc2_:NewChickenBoxItem = null;
         if(this.frame)
         {
            this.frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.frame.dispose();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._model.templateIDList.length)
         {
            _loc2_ = this._model.itemList[_loc1_] as NewChickenBoxItem;
            _loc2_.dispose();
            _loc2_ = null;
            _loc1_++;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
