package hallIcon.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   
   public class HallIconPanel extends Sprite implements Disposeable
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const BOTTOM:String = "bottom";
       
      
      private var _mainIcon:DisplayObject;
      
      private var _mainIconString:String;
      
      private var _hotNumBg:Bitmap;
      
      private var _hotNum:FilterFrameText;
      
      private var _iconArray:Array;
      
      private var _iconBox:HallIconBox;
      
      private var direction:String;
      
      private var vNum:int;
      
      private var hNum:int;
      
      private var WHSize:Array;
      
      private var tweenLiteMax:TweenLite;
      
      private var tweenLiteSmall:TweenLite;
      
      private var isExpand:Boolean;
      
      public function HallIconPanel($mainIconString:String, $direction:String = "left", $hNum:int = -1, $vNum:int = -1, $WHSize:Array = null)
      {
         super();
         this._mainIconString = $mainIconString;
         this.direction = $direction;
         this.hNum = $hNum;
         this.vNum = $vNum;
         if(this.hNum == -1 && this.vNum == -1)
         {
            this.vNum = 1;
         }
         if($WHSize == null)
         {
            $WHSize = [78,78];
         }
         this.WHSize = $WHSize;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._mainIcon = ComponentFactory.Instance.creat(this._mainIconString);
         if(this._mainIcon is Sprite)
         {
            Sprite(this._mainIcon).buttonMode = true;
            Sprite(this._mainIcon).mouseChildren = false;
         }
         addChild(this._mainIcon);
         this._hotNumBg = ComponentFactory.Instance.creatBitmap("assets.hallIcon.hotNumBg");
         addChild(this._hotNumBg);
         this._hotNum = ComponentFactory.Instance.creatComponentByStylename("hallicon.hallIconPanel.hotNum");
         this._hotNum.text = "0";
         addChild(this._hotNum);
         this.updateHotNum();
         this._iconArray = new Array();
         this._iconBox = new HallIconBox();
         this._iconBox.visible = false;
         addChild(this._iconBox);
      }
      
      private function initEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__mainIconHandler);
      }
      
      public function addIcon($icon:DisplayObject, $icontype:String, $orderId:int = 0, flag:Boolean = false) : DisplayObject
      {
         this._iconBox.addChild($icon);
         var obj:Object = {};
         obj.icon = $icon;
         obj.icontype = $icontype;
         obj.orderId = $orderId;
         obj.flag = flag;
         this._iconArray.push(obj);
         this.arrange();
         return $icon;
      }
      
      public function getIconByType($icontype:String) : DisplayObject
      {
         var tempChild:DisplayObject = null;
         var tempType:String = null;
         for(var i:int = 0; i < this._iconArray.length; i++)
         {
            tempType = this._iconArray[i].icontype;
            if(tempType == $icontype)
            {
               tempChild = this._iconArray[i].icon;
               break;
            }
         }
         return tempChild;
      }
      
      public function removeIconByType($icontype:String) : void
      {
         var tempChild:DisplayObject = null;
         var tempIconType:String = null;
         var tempIndex:int = 0;
         for(var i:int = 0; i < this._iconArray.length; i++)
         {
            tempIconType = this._iconArray[i].icontype;
            if(tempIconType == $icontype)
            {
               tempChild = this._iconArray[i].icon;
               this._iconArray.splice(i,1);
               break;
            }
         }
         if(tempChild)
         {
            tempIndex = this._iconBox.getChildIndex(tempChild);
            if(tempIndex != -1)
            {
               this._iconBox.removeChildAt(tempIndex);
            }
         }
         if(tempChild)
         {
            ObjectUtils.disposeObject(tempChild);
         }
         this.arrange();
      }
      
      public function arrange() : void
      {
         this.iconSortOn();
         this.updateIconsPos();
         if(this.isExpand)
         {
            this.updateDirectionPos();
         }
         this.updateHotNum();
      }
      
      private function updateIconsPos() : void
      {
         var tempChild:DisplayObject = null;
         for(var i:int = 0; i < this._iconArray.length; i++)
         {
            tempChild = this._iconArray[i].icon;
            if(this.hNum == -1)
            {
               tempChild.x = i * this.WHSize[0];
            }
            else
            {
               tempChild.x = int(i % this.hNum) * this.WHSize[0];
            }
            if(this.vNum == -1)
            {
               tempChild.y = int(i / this.hNum) * this.WHSize[1];
            }
            else
            {
               tempChild.y = i * this.WHSize[1];
            }
         }
      }
      
      private function updateDirectionPos() : void
      {
         if(this.direction == LEFT)
         {
            this._iconBox.x = -this.getIconSpriteWidth() - 10;
            this._iconBox.y = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
         }
         else if(this.direction == RIGHT)
         {
            this._iconBox.x = this._mainIcon.x + this._mainIcon.width + 10;
            this._iconBox.y = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
         }
         else if(this.direction == BOTTOM)
         {
            if(HallIconManager.instance.model.firstRechargeIsOpen && this._iconArray[0].flag)
            {
               this._iconBox.x = -350;
            }
            else
            {
               this._iconBox.x = -(this.getIconSpriteWidth() - this.WHSize[0]);
            }
            this._iconBox.y = this._mainIcon.y + this.WHSize[1] + 5;
         }
      }
      
      public function iconSortOn() : void
      {
         if(this._iconArray.length > 1)
         {
            this._iconArray.sort(this.sortFunctin);
         }
      }
      
      private function sortFunctin(a:Object, b:Object) : Number
      {
         if(a.orderId > b.orderId)
         {
            return 1;
         }
         if(a.orderId < b.orderId)
         {
            return -1;
         }
         return 0;
      }
      
      public function expand($isBool:Boolean) : void
      {
         var moveY:Number = NaN;
         var moveX:Number = NaN;
         moveY = NaN;
         if(this.isExpand != $isBool && this._iconArray && this._iconArray.length > 0)
         {
            this.isExpand = $isBool;
            if(this.isExpand)
            {
               moveX = 0;
               moveY = 0;
               if(this.direction == LEFT)
               {
                  moveX = -this.getIconSpriteWidth() - 10;
                  moveY = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
               }
               else if(this.direction == RIGHT)
               {
                  moveX = this._mainIcon.x + this._mainIcon.width + 10;
                  moveY = -(this.getIconSpriteHeight() - this.WHSize[1]) / 2;
               }
               else if(this.direction == BOTTOM)
               {
                  if(HallIconManager.instance.model.firstRechargeIsOpen && this._iconArray[0].flag)
                  {
                     moveX = -350;
                  }
                  else
                  {
                     moveX = -(this.getIconSpriteWidth() - this.WHSize[0]);
                  }
                  moveY = this._mainIcon.y + this.WHSize[1] + 5;
               }
               this._iconBox.x = this._mainIcon.x;
               this._iconBox.y = 0;
               this._iconBox.scaleX = 0;
               this._iconBox.scaleY = 0;
               this._iconBox.alpha = 0;
               this._iconBox.visible = true;
               this.tweenLiteMax = TweenLite.to(this._iconBox,0.2,{
                  "x":moveX,
                  "y":moveY,
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "onComplete":this.tweenLiteMaxCloseComplete
               });
            }
            else
            {
               this.tweenLiteSmall = TweenLite.to(this._iconBox,0.2,{
                  "x":this._mainIcon.x,
                  "y":0,
                  "alpha":0,
                  "scaleX":0,
                  "scaleY":0,
                  "onComplete":this.tweenLiteSmallCloseComplete
               });
            }
         }
      }
      
      private function tweenLiteSmallCloseComplete() : void
      {
         this.killTweenLiteSmall();
         this._iconBox.visible = false;
      }
      
      private function tweenLiteMaxCloseComplete() : void
      {
         this.killTweenLiteMax();
      }
      
      private function getIconSpriteWidth() : Number
      {
         var tempW:Number = 0;
         if(this._iconArray.length == 0)
         {
            tempW = 0;
         }
         else if(this.hNum == -1)
         {
            tempW = this._iconArray.length * this.WHSize[0];
         }
         else if(this._iconArray.length >= this.hNum)
         {
            tempW = this.hNum * this.WHSize[0];
         }
         else
         {
            tempW = this._iconArray.length * this.WHSize[0];
         }
         return tempW;
      }
      
      private function getIconSpriteHeight() : Number
      {
         var tempN:int = 0;
         var tempH:Number = 0;
         if(this._iconArray.length == 0)
         {
            tempH = 0;
         }
         else if(this.hNum == -1)
         {
            tempH = this.WHSize[1];
         }
         else if(this._iconArray.length >= this.hNum)
         {
            tempN = this._iconArray.length / this.hNum;
            if(this._iconArray.length % this.hNum)
            {
               tempN += 1;
            }
            tempH = tempN * this.WHSize[1];
         }
         else
         {
            tempH = this.WHSize[1];
         }
         return tempH;
      }
      
      private function __mainIconHandler(evt:MouseEvent) : void
      {
         if(evt.target == this._mainIcon)
         {
            SoundManager.instance.play("008");
            if(this._iconArray && this._iconArray.length > 0)
            {
               if(this._iconBox.visible)
               {
                  this.expand(false);
               }
               else
               {
                  this.expand(true);
               }
            }
         }
         else
         {
            this.expand(false);
         }
      }
      
      private function updateHotNum() : void
      {
         var isBool:Boolean = false;
         if(this._iconArray && this._iconArray.length > 0)
         {
            isBool = true;
            this._hotNum.text = this._iconArray.length + "";
         }
         else
         {
            this._hotNum.text = "0";
         }
         this._hotNumBg.visible = this._hotNum.visible = isBool;
      }
      
      public function get mainIcon() : DisplayObject
      {
         return this._mainIcon;
      }
      
      public function get count() : int
      {
         return this._iconArray.length;
      }
      
      override public function get height() : Number
      {
         if(this._mainIcon)
         {
            return this._mainIcon.height;
         }
         return 0;
      }
      
      override public function get width() : Number
      {
         if(this._mainIcon)
         {
            return this._mainIcon.width;
         }
         return 0;
      }
      
      private function killTweenLiteMax() : void
      {
         if(!this.tweenLiteMax)
         {
            return;
         }
         this.tweenLiteMax.kill();
         this.tweenLiteMax = null;
      }
      
      private function killTweenLiteSmall() : void
      {
         if(!this.tweenLiteSmall)
         {
            return;
         }
         this.tweenLiteSmall.kill();
         this.tweenLiteSmall = null;
      }
      
      private function removeEvent() : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__mainIconHandler);
      }
      
      public function dispose() : void
      {
         this.killTweenLiteMax();
         this.killTweenLiteSmall();
         this.removeEvent();
         ObjectUtils.disposeObject(this._mainIcon);
         this._mainIcon = null;
         ObjectUtils.disposeObject(this._hotNumBg);
         this._hotNumBg = null;
         ObjectUtils.disposeObject(this._hotNum);
         this._hotNum = null;
         ObjectUtils.disposeObject(this._iconBox);
         this._iconBox = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         this._iconArray = null;
         this.WHSize = null;
         this.direction = null;
         this._mainIconString = null;
         this.vNum = 0;
         this.hNum = 0;
      }
   }
}
