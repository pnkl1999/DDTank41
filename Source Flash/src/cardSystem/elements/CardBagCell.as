package cardSystem.elements
{
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardBagCell extends CardCell
   {
       
      
      private var _upGradeBtn:BaseButton;
      
      private var _resetGradeBtn:BaseButton;
      
      private var _buttonAndNumBG:Bitmap;
      
      private var _count:FilterFrameText;
      
      private var _timeLine:TimelineMax;
      
      private var _isMouseOver:Boolean;
      
      private var _tween0:TweenLite;
      
      private var _tween1:TweenLite;
      
      private var _tween2:TweenLite;
      
      private var _tween3:TweenLite;
      
      private var _mainCardLight:Bitmap;
      
      public function CardBagCell(param1:DisplayObject, param2:int = -1, param3:CardInfo = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._buttonAndNumBG = ComponentFactory.Instance.creatBitmap("asset.cardBag.cell.buttonbg");
         this._count = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.count");
         this._mainCardLight = ComponentFactory.Instance.creatBitmap("asset.cardBag.mainCardLight");
         addChild(this._buttonAndNumBG);
         addChild(this._count);
         addChild(this._mainCardLight);
         this._mainCardLight.visible = false;
         this._count.alpha = 0;
         this._buttonAndNumBG.alpha = 0;
         this._timeLine = new TimelineMax();
         this._timeLine.addEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         this._tween0 = new TweenLite(_starContainer,0.05,{
            "autoAlpha":0,
            "y":"5"
         });
         this._timeLine.append(this._tween0);
         this._tween1 = new TweenLite(this._buttonAndNumBG,0.1,{
            "autoAlpha":1,
            "y":"-5"
         });
         this._timeLine.append(this._tween1);
         this._timeLine.stop();
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         if(cardInfo && cardInfo.isFirstGet)
         {
            stopShine();
            if(PlayerManager.Instance.Self.cardBagDic[cardInfo.Place])
            {
               PlayerManager.Instance.Self.cardBagDic[cardInfo.Place].isFirstGet = false;
            }
         }
         if(cardInfo == null)
         {
            return;
         }
         this._isMouseOver = true;
         this._timeLine.play();
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         if(cardInfo == null)
         {
            return;
         }
         this._isMouseOver = false;
         this.__timelineComplete();
      }
      
      private function __timelineComplete(param1:TweenEvent = null) : void
      {
         if(this._timeLine.currentTime < this._timeLine.totalDuration)
         {
            return;
         }
         if(this._isMouseOver || locked)
         {
            return;
         }
         this._timeLine.reverse();
      }
      
      protected function __upGrade(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         CardControl.Instance.showUpGradeFrame(cardInfo);
      }
      
      protected function __propReset(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         CardControl.Instance.showPropResetFrame(cardInfo);
      }
      
      override public function set cardInfo(param1:CardInfo) : void
      {
         super.cardInfo = param1;
         setStar();
         if(cardInfo)
         {
            if(cardInfo.isFirstGet && canShine)
            {
               shine();
            }
            else
            {
               stopShine();
            }
            this._count.text = String(cardInfo.Count);
            if(this._tween2)
            {
               this._tween2.kill();
               this._timeLine.remove(this._tween2);
            }
            if(cardInfo.Count == 0)
            {
               this._count.visible = false;
            }
            else
            {
               this._count.visible = true;
               this._count.alpha = 0;
               this._tween2 = new TweenLite(this._count,0.05,{"autoAlpha":1});
               this._timeLine.append(this._tween2,-0.1);
            }
            if(this._tween3)
            {
               this._tween3.kill();
               this._timeLine.remove(this._tween3);
            }
            if(cardInfo.Level >= EquipType.CardMaxLv)
            {
               if(this._resetGradeBtn == null)
               {
                  this._resetGradeBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.propReset");
                  addChild(this._resetGradeBtn);
                  this._resetGradeBtn.alpha = 0;
                  this._resetGradeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__propReset);
               }
               this._resetGradeBtn.visible = true;
               this._resetGradeBtn.alpha = 0;
               if(this._upGradeBtn)
               {
                  this._upGradeBtn.visible = false;
               }
               this._tween3 = new TweenLite(this._resetGradeBtn,0.05,{"alpha":1});
               this._timeLine.append(this._tween3,-0.15);
            }
            else
            {
               if(this._upGradeBtn == null)
               {
                  this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.upGradeBtn");
                  addChild(this._upGradeBtn);
                  this._upGradeBtn.alpha = 0;
                  this._upGradeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__upGrade);
               }
               this._upGradeBtn.visible = true;
               this._upGradeBtn.alpha = 0;
               if(this._resetGradeBtn)
               {
                  this._resetGradeBtn.visible = false;
               }
               this._tween3 = new TweenLite(this._upGradeBtn,0.05,{"alpha":1});
               this._timeLine.append(this._tween3,-0.15);
            }
            if(CardControl.Instance.signLockedCard == cardInfo.TemplateID)
            {
               this.locked = true;
            }
            if(cardInfo.templateInfo.Property8 == "1")
            {
               this._mainCardLight.visible = true;
            }
            else
            {
               this._mainCardLight.visible = false;
            }
         }
         else
         {
            stopShine();
            this._count.text = "";
            this._timeLine.restart();
            this._timeLine.stop();
            _starContainer.visible = false;
            this._mainCardLight.visible = false;
            if(this._upGradeBtn)
            {
               this._upGradeBtn.visible = false;
            }
            if(this._resetGradeBtn)
            {
               this._resetGradeBtn.visible = false;
            }
            this._count.visible = false;
            this._buttonAndNumBG.visible = false;
         }
      }
      
      override public function get width() : Number
      {
         return _bg.width;
      }
      
      override public function get height() : Number
      {
         return _bg.height;
      }
      
      override public function dispose() : void
      {
         this._timeLine.removeEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         if(this._upGradeBtn)
         {
            this._upGradeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__upGrade);
         }
         ObjectUtils.disposeObject(this._upGradeBtn);
         this._upGradeBtn = null;
         if(this._resetGradeBtn)
         {
            this._resetGradeBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__propReset);
         }
         ObjectUtils.disposeObject(this._resetGradeBtn);
         this._resetGradeBtn = null;
         this._timeLine.kill();
         this._timeLine = null;
         ObjectUtils.disposeAllChildren(this);
         this._count = null;
         this._buttonAndNumBG = null;
         super.dispose();
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.height = _contentHeight;
            param1.width = _contentWidth;
            param1.x = (_bg.width - _contentWidth) / 2;
            param1.y = (_bg.height - _contentHeight) / 2;
         }
      }
      
      override protected function createContentComplete() : void
      {
         clearLoading();
         this.updateSize(_pic);
      }
      
      override public function set locked(param1:Boolean) : void
      {
         super.locked = param1;
         if(param1 == true)
         {
            this._timeLine.restart();
            this._timeLine.stop();
         }
      }
   }
}
