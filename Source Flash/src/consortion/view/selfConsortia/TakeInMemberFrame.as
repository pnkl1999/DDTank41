package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ClassUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaApplyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TakeInMemberFrame extends Frame
   {
       
      
      private var _bg:MovieClip;
      
      private var _name:Bitmap;
      
      private var _operate:Bitmap;
      
      private var _level:BaseButton;
      
      private var _power:BaseButton;
      
      private var _selectAll:BaseButton;
      
      private var _agree:BaseButton;
      
      private var _refuse:BaseButton;
      
      private var _setRefuse:SelectedCheckButton;
      
      private var _refuseImg:Bitmap;
      
      private var _takeIn:TextButton;
      
      private var _close:TextButton;
      
      private var _list:VBox;
      
      private var _lastSort:String;
      
      private var _items:Array;
      
      private var _turnPage:TakeInTurnPage;
      
      public function TakeInMemberFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.titleText");
         this._bg = ClassUtils.CreatInstance("asset.consortion.takeIn.bg") as MovieClip;
         PositionUtils.setPos(this._bg,"consortion.takeIn.bgPos");
         this._name = ComponentFactory.Instance.creatBitmap("asset.consortion.takeIn.name");
         this._operate = ComponentFactory.Instance.creatBitmap("asset.consortion.takeIn.operate");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.level");
         this._power = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.power");
         this._selectAll = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.selectAll");
         this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.agree");
         this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.refuse");
         this._setRefuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.setRefuse");
         this._refuseImg = ComponentFactory.Instance.creatBitmap("asset.consortion.takeIn.refuseWord");
         this._takeIn = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.takeIn");
         this._close = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.close");
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.list");
         this._turnPage = ComponentFactory.Instance.creatCustomObject("takeInTurnPage");
         addToContent(this._bg);
         addToContent(this._name);
         addToContent(this._operate);
         addToContent(this._level);
         addToContent(this._power);
         addToContent(this._selectAll);
         addToContent(this._agree);
         addToContent(this._refuse);
         addToContent(this._setRefuse);
         this._setRefuse.addChild(this._refuseImg);
         addToContent(this._takeIn);
         addToContent(this._close);
         addToContent(this._list);
         addToContent(this._turnPage);
         this._takeIn.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.okLabel");
         this._close.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         this._setRefuse.visible = PlayerManager.Instance.Self.consortiaInfo.ChairmanID == PlayerManager.Instance.Self.ID ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._setRefuse.selected = !PlayerManager.Instance.Self.consortiaInfo.OpenApply;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._level.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._power.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._selectAll.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._agree.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._refuse.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._setRefuse.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._takeIn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._turnPage.addEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__refishListHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,this.__consortiaApplyStatusResult);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._level.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._power.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._selectAll.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._agree.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._refuse.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._setRefuse.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._takeIn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._turnPage.removeEventListener(TakeInTurnPage.PAGE_CHANGE,this.__pageChangeHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__refishListHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,this.__consortiaApplyStatusResult);
      }
      
      private function __pageChangeHandler(param1:Event) : void
      {
         this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present));
      }
      
      private function __consortiaApplyStatusResult(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         MessageTipManager.getInstance().show(_loc4_);
         this._setRefuse.selected = Boolean(!_loc2_);
         PlayerManager.Instance.Self.consortiaInfo.OpenApply = Boolean(_loc2_);
      }
      
      private function __refishListHandler(param1:ConsortionEvent) : void
      {
         this._lastSort = "";
         this._turnPage.sum = Math.ceil(ConsortionModelControl.Instance.model.myApplyList.length / 10);
         this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present));
      }
      
      private function clearList() : void
      {
         var _loc1_:int = 0;
         this._list.disposeAllChildren();
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_] = null;
               _loc1_++;
            }
            this._items = null;
         }
         this._items = new Array();
      }
      
      private function setList(param1:Vector.<ConsortiaApplyInfo>) : void
      {
         var _loc4_:TakeInMemberItem = null;
         this.clearList();
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TakeInMemberItem();
            _loc4_.info = param1[_loc3_];
            this._list.addChild(_loc4_);
            this._items.push(_loc4_);
            _loc3_++;
         }
         if(this._lastSort != "")
         {
            this.sort(this._lastSort);
         }
      }
      
      private function sort(param1:String) : void
      {
         var _loc4_:TakeInMemberItem = null;
         var _loc5_:TakeInMemberItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc4_ = this._items[_loc2_] as TakeInMemberItem;
            this._list.removeChild(_loc4_);
            _loc2_++;
         }
         this._items.sortOn(param1,Array.DESCENDING | Array.NUMERIC);
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc5_ = this._items[_loc3_] as TakeInMemberItem;
            this._list.addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:WantTakeInFrame = null;
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._level:
               this._lastSort = "Level";
               this.sort(this._lastSort);
               break;
            case this._power:
               this._lastSort = "FightPower";
               this.sort(this._lastSort);
               break;
            case this._selectAll:
               this.selectAll();
               break;
            case this._agree:
               this.agree();
               break;
            case this._refuse:
               this.refuse();
               break;
            case this._setRefuse:
               SocketManager.Instance.out.sendConsoritaApplyStatusOut(!this._setRefuse.selected);
               break;
            case this._takeIn:
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("wantTakeInFrame");
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._close:
               this.dispose();
         }
      }
      
      private function selectAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.allHasSelected())
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               if(this._items[_loc1_])
               {
                  (this._items[_loc1_] as TakeInMemberItem).selected = false;
               }
               _loc1_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this._items.length)
            {
               if(this._items[_loc2_])
               {
                  (this._items[_loc2_] as TakeInMemberItem).selected = true;
               }
               _loc2_++;
            }
         }
      }
      
      private function allHasSelected() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._items.length)
         {
            if(!(this._items[_loc1_] as TakeInMemberItem).selected)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function agree() : void
      {
         var _loc3_:TakeInMemberItem = null;
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc3_ = this._items[_loc2_] as TakeInMemberItem;
            if(_loc3_)
            {
               if(_loc3_.selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinPass(_loc3_.info.ID);
                  _loc1_ = false;
               }
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      private function refuse() : void
      {
         var _loc3_:TakeInMemberItem = null;
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc3_ = this._items[_loc2_] as TakeInMemberItem;
            if(_loc3_)
            {
               if((this._items[_loc2_] as TakeInMemberItem).selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinDelete(_loc3_.info.ID);
                  _loc1_ = false;
               }
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._name = null;
         this._operate = null;
         this._level = null;
         this._power = null;
         this._selectAll = null;
         this._agree = null;
         this._refuse = null;
         this._setRefuse = null;
         this._takeIn = null;
         this._close = null;
         this._list = null;
         this._refuseImg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
