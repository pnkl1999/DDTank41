package newChickenBox.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   
   public class NewChickenBoxItem extends Sprite
   {
       
      
      private var _bg:MovieClip;
      
      private var _cell:NewChickenBoxCell;
      
      private var _position:int;
      
      public var info:NewChickenBoxGoodsTempInfo;
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      protected var _currentFrameIndex:int = 1;
      
      protected var _tbxCount:FilterFrameText;
      
      public function NewChickenBoxItem(param1:NewChickenBoxCell, param2:MovieClip)
      {
         super();
         this._cell = param1;
         this._bg = param2;
         this._bg.addEventListener("showItem",this.showItem);
         this._bg.addEventListener("hideItem",this.hideItem);
         this._bg.addEventListener("alphaItem",this.alphaItem);
         addChild(this._bg);
         addChild(this._cell);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.CountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this.updateCount();
         this.buttonMode = true;
         this.filterString = "null,lightFilter,null,grayFilter";
         this.addEvent();
      }
      
      public function countTextShowIf() : void
      {
         if(this.info.IsSelected)
         {
            this._tbxCount.visible = true;
         }
         else if(this.info.IsSeeded)
         {
            this._tbxCount.visible = true;
            this._tbxCount.alpha = 0.5;
         }
         else
         {
            this._tbxCount.visible = false;
         }
      }
      
      public function updateCount() : void
      {
         if(this._tbxCount)
         {
            if(this.info && this.info.Count > 1)
            {
               this._tbxCount.text = String(this.info.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      public function setBg(param1:int) : void
      {
         if(param1 == 0)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            this.cell.visible = true;
         }
         else if(param1 == 1)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            this.cell.visible = true;
         }
         else if(param1 == 2)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
            this.cell.visible = true;
         }
         else if(param1 == 3)
         {
            this.bg = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
            this.cell.visible = false;
         }
         this.setChildIndex(this.cell,0);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            this._bg.removeEventListener("showItem",this.showItem);
            this._bg.removeEventListener("hideItem",this.hideItem);
            this._bg.removeEventListener("alphaItem",this.alphaItem);
            this._bg = null;
         }
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this._tbxCount)
         {
            ObjectUtils.disposeObject(this._tbxCount);
         }
         this._tbxCount = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set filterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this._frameFilter = ComponentFactory.Instance.creatFrameFilters(this._filterString);
      }
      
      public function get frameFilter() : Array
      {
         return this._frameFilter;
      }
      
      public function set frameFilter(param1:Array) : void
      {
         this._frameFilter = param1;
      }
      
      private function alphaItem(param1:Event) : void
      {
         this._cell.visible = true;
         this._cell.alpha = 0.5;
         this.updateCount();
         if(this._tbxCount)
         {
            this._tbxCount.alpha = 0.5;
         }
      }
      
      private function showItem(param1:Event) : void
      {
         this._cell.visible = true;
         this.updateCount();
      }
      
      private function hideItem(param1:Event) : void
      {
         this._cell.visible = false;
         if(this._tbxCount)
         {
            this._tbxCount.visible = false;
         }
      }
      
      public function get cell() : NewChickenBoxCell
      {
         return this._cell;
      }
      
      public function set cell(param1:NewChickenBoxCell) : void
      {
         if(this._cell != null && this._cell.parent != null)
         {
            this._cell.parent.removeChild(this._cell);
         }
         this._cell = param1;
         this.addChild(this._cell);
      }
      
      public function get bg() : MovieClip
      {
         return this._bg;
      }
      
      public function set bg(param1:MovieClip) : void
      {
         if(this._bg != null && this._bg.parent != null)
         {
            this._bg.removeEventListener("showItem",this.showItem);
            this._bg.removeEventListener("hideItem",this.hideItem);
            this._bg.removeEventListener("alphaItem",this.alphaItem);
            this._bg.parent.removeChild(this._bg);
            this._bg = null;
         }
         this._bg = param1;
         this._bg.addEventListener("showItem",this.showItem);
         this._bg.addEventListener("hideItem",this.hideItem);
         this._bg.addEventListener("alphaItem",this.alphaItem);
         this.addChild(this._bg);
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(param1:int) : void
      {
         this._position = param1;
      }
      
      public function setFrame(param1:int) : void
      {
         filters = this._frameFilter[param1 - 1];
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         this.setFrame(1);
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         this.setFrame(2);
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
      }
   }
}
