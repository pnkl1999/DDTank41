package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.data.ConsortionSkillInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortionSkillItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _sign:Bitmap;
      
      private var _level:int;
      
      private var _open:Boolean;
      
      private var _isMetal:Boolean;
      
      private var _cells:Vector.<ConsortionSkillCell>;
      
      private var _btns:Vector.<ConsortionSkillItenBtn>;
      
      private var _currentInfo:ConsortionSkillInfo;
      
      public function ConsortionSkillItem(param1:int, param2:Boolean, param3:Boolean = false)
      {
         super();
         this._level = param1;
         this._open = param2;
         this._isMetal = param3;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.skilItem.bg1");
         this._sign = ComponentFactory.Instance.creatBitmap("asset.consortion.skilItem.level" + this._level);
         if(this._level == 10)
         {
            PositionUtils.setPos(this._sign,"consortion.killItem.levelPos10");
         }
         else
         {
            PositionUtils.setPos(this._sign,"consortion.killItem.levelPos");
         }
         addChild(this._bg);
         addChild(this._sign);
         if(!this._open)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
         this._cells = new Vector.<ConsortionSkillCell>(2);
         this._btns = new Vector.<ConsortionSkillItenBtn>(2);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         if(this._open)
         {
            _loc1_ = 0;
            while(_loc1_ < this._cells.length)
            {
               if(this._cells[_loc1_])
               {
                  this._cells[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               }
               if(this._btns[_loc1_])
               {
                  this._btns[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
               }
               _loc1_++;
            }
         }
      }
      
      public function set data(param1:Vector.<ConsortionSkillInfo>) : void
      {
         var _loc3_:ConsortionSkillCell = null;
         var _loc4_:ConsortionSkillItenBtn = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ConsortionSkillCell();
            _loc3_.tipData = param1[_loc2_];
            _loc3_.contentRect(54,54);
            addChild(_loc3_);
            PositionUtils.setPos(_loc3_,"consortion.killItem.cellPos" + _loc2_);
            _loc4_ = new ConsortionSkillItenBtn();
            addChild(_loc4_);
            PositionUtils.setPos(_loc4_,"consortion.killItem.btnPos" + _loc2_);
            if(param1[_loc2_].type == 1)
            {
               _loc4_.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),param1[_loc2_].riches + LanguageMgr.GetTranslation("consortia.Money"));
            }
            else if(this._isMetal)
            {
               _loc4_.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),param1[_loc2_].metal + LanguageMgr.GetTranslation("medal"));
            }
            else
            {
               _loc4_.setValue(LanguageMgr.GetTranslation("ddt.consortion.skillItem.oneDay"),param1[_loc2_].riches + LanguageMgr.GetTranslation("ddt.consortion.skillCell.btnPersonal.rich"));
            }
            _loc3_.addEventListener(MouseEvent.CLICK,this.__clickHandler);
            _loc4_.addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this._cells[_loc2_] = _loc3_;
            this._btns[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(param1.currentTarget is ConsortionSkillCell)
         {
            this._currentInfo = (param1.currentTarget as ConsortionSkillCell).info;
         }
         else
         {
            this._currentInfo = this._cells[this._btns.indexOf(param1.currentTarget as ConsortionSkillItenBtn)].info;
         }
         if(this._currentInfo.type == ConsortionModel.CONSORTION_SKILL && PlayerManager.Instance.Self.DutyLevel > 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.SkillFrame.info"));
            return;
         }
         if(!this._open)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.open"));
            return;
         }
         var _loc2_:ConsortionOpenSkillFrame = ComponentFactory.Instance.creatComponentByStylename("consortionOpenSkillFrame");
         _loc2_.isMetal = this._isMetal;
         _loc2_.info = this._currentInfo;
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __confirmResponseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendConsortionSkill(false,this._currentInfo.id,0);
         }
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponseHandler);
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this._cells[_loc1_] = null;
            this._btns[_loc1_] = null;
            _loc1_++;
         }
         this._bg = null;
         this._sign = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
