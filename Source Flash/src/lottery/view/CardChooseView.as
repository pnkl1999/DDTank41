package lottery.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import lottery.cell.SmallCardCell;
   import lottery.events.LotteryEvent;
   
   public class CardChooseView extends Sprite implements Disposeable
   {
      
      private static const LOTTERY_MONEY:Number = 2000;
      
      private static const CARD_LIMIT:int = 24;
      
      private static const SELECTED_LIMIT:int = 5;
       
      
      private var _selectedCount:int;
      
      private var _bg:Bitmap;
      
      private var _leftView:CardChooseLeftView;
      
      private var _rightView:CardChooseRightView;
      
      private var _isEffectComplete:Boolean = true;
      
      public function CardChooseView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.lottery.cardChooseViewbg");
         addChild(this._bg);
         this._leftView = new CardChooseLeftView();
         addChild(this._leftView);
         this._rightView = new CardChooseRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
         this._leftView.addEventListener(LotteryEvent.CARD_SELECT,this.__cardSelect);
         this._rightView.addEventListener(LotteryEvent.CARD_CANCEL,this.__cardCancel);
         this._rightView.addEventListener(LotteryEvent.CARD_CANCEL_ALL,this.__cardCancelAll);
      }
      
      private function __cardSelect(param1:LotteryEvent) : void
      {
         if(!this._isEffectComplete)
         {
            return;
         }
         if(this._rightView.isSelectFull)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.chosenLimit",SELECTED_LIMIT));
            return;
         }
         var _loc2_:SmallCardCell = SmallCardCell(param1.paras[0]);
         if(_loc2_.enable == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.haveChosen"));
            return;
         }
         var _loc3_:DisplayObject = this._rightView.getEmptyCardCell();
         var _loc4_:Point = DisplayUtils.localizePoint(parent,_loc3_);
         _loc4_.offset(50,40);
         ++this._selectedCount;
         this.addCardEffects(_loc2_,_loc4_);
         _loc2_.enable = false;
         this._rightView.enable = false;
      }
      
      private function __cardCancel(param1:LotteryEvent) : void
      {
         this._leftView.resetCardById(param1.paras[0]);
      }
      
      private function __cardCancelAll(param1:LotteryEvent) : void
      {
         this._leftView.resetAllCard();
      }
      
      private function addCardEffects(param1:SmallCardCell, param2:Point) : void
      {
         var _loc5_:TweenProxy = null;
         var _loc6_:TimelineLite = null;
         var _loc7_:TweenLite = null;
         var _loc8_:TweenLite = null;
         var _loc9_:TweenLite = null;
         if(!param1)
         {
            return;
         }
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc3_.draw(param1.asDisplayObject());
         var _loc4_:Bitmap = new Bitmap(_loc3_,"auto",true);
         parent.addChild(_loc4_);
         _loc5_ = TweenProxy.create(_loc4_);
         _loc5_.registrationX = _loc5_.width / 2;
         _loc5_.registrationY = _loc5_.height / 2;
         var _loc10_:Point = DisplayUtils.localizePoint(parent,param1);
         _loc5_.x = _loc10_.x + _loc5_.width / 2;
         _loc5_.y = _loc10_.y + _loc5_.height / 2;
         _loc6_ = new TimelineLite();
         _loc6_.vars.onComplete = this.twComplete;
         _loc6_.vars.onCompleteParams = [_loc6_,_loc5_,_loc4_,param1.cardId];
         _loc7_ = new TweenLite(_loc5_,0.3,{
            "scaleX":1.8,
            "scaleY":1.8
         });
         _loc8_ = new TweenLite(_loc5_,0.3,{
            "x":param2.x,
            "y":param2.y
         });
         _loc9_ = new TweenLite(_loc5_,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         _loc6_.append(_loc7_,0.2);
         _loc6_.append(_loc8_);
         _loc6_.append(_loc9_,-0.2);
         this._isEffectComplete = false;
      }
      
      private function twComplete(param1:TimelineLite, param2:TweenProxy, param3:Bitmap, param4:int) : void
      {
         if(param1)
         {
            param1.kill();
         }
         if(param2)
         {
            param2.destroy();
         }
         if(param3.parent)
         {
            param3.parent.removeChild(param3);
            param3.bitmapData.dispose();
         }
         param2 = null;
         param3 = null;
         param1 = null;
         this._rightView.setLastEmptyCardId(param4);
         this._rightView.enable = true;
         this._isEffectComplete = true;
      }
      
      private function removeEvent() : void
      {
         this._leftView.removeEventListener(LotteryEvent.CARD_SELECT,this.__cardSelect);
         this._rightView.removeEventListener(LotteryEvent.CARD_CANCEL,this.__cardCancel);
         this._rightView.removeEventListener(LotteryEvent.CARD_CANCEL_ALL,this.__cardCancelAll);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._leftView)
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(this._rightView)
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
