package com.pickgliss.ui
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shader;
   import flash.filters.ShaderFilter;
   import flash.utils.Dictionary;
   
   public final class ComponentModel
   {
       
      
      private var _allTipStyles:Vector.<String>;
      
      private var _bitmapSets:Dictionary;
      
      private var _componentStyle:Dictionary;
      
      private var _currentComponentSet:XML;
      
      private var _customObjectStyle:Dictionary;
      
      private var _loadedComponentSet:Vector.<String>;
      
      private var _shaderData:Dictionary;
      
      private var _styleSets:Dictionary;
      
      public function ComponentModel()
      {
         super();
         this._componentStyle = new Dictionary();
         this._customObjectStyle = new Dictionary();
         this._styleSets = new Dictionary();
         this._allTipStyles = new Vector.<String>();
         this._shaderData = new Dictionary();
         this._bitmapSets = new Dictionary();
         this._loadedComponentSet = new Vector.<String>();
      }
      
      public function get allComponentStyle() : Dictionary
      {
         return this._componentStyle;
      }
      
      public function addBitmapSet(param1:String, param2:XML) : void
      {
         this._bitmapSets[param1] = param2;
      }
      
      public function addComponentSet(param1:XML) : void
      {
         if(this._loadedComponentSet.indexOf(String(param1.@name)) != -1)
         {
            return;
         }
         this._currentComponentSet = param1;
         this._loadedComponentSet.push(String(this._currentComponentSet.@name));
         this.paras();
      }
      
      public function get allTipStyles() : Vector.<String>
      {
         return this._allTipStyles;
      }
      
      public function getBitmapSet(param1:String) : XML
      {
         return this._bitmapSets[param1];
      }
      
      public function getComonentStyle(param1:String) : XML
      {
         return this._componentStyle[param1];
      }
      
      public function getCustomObjectStyle(param1:String) : XML
      {
         return this._customObjectStyle[param1];
      }
      
      public function getSet(param1:String) : *
      {
         return this._styleSets[param1];
      }
      
      private function __onShaderLoadComplete(param1:LoaderEvent) : void
      {
         var _loc7_:Array = null;
         var _loc2_:Object = this.findShaderDataByLoader(param1.loader);
         var _loc3_:Shader = new Shader(_loc2_.loader.content);
         var _loc4_:ShaderFilter = new ShaderFilter(_loc3_);
         var _loc5_:Array = ComponentFactory.parasArgs(_loc2_.xml.@paras);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = String(_loc5_[_loc6_]).split(":");
            if(_loc4_.shader.data.hasOwnProperty(_loc7_[0]))
            {
               _loc4_.shader.data[_loc7_[0]].value = [int(_loc7_[1])];
            }
            _loc6_++;
         }
         this._styleSets[String(_loc2_.xml.@shadername)] = _loc4_;
      }
      
      private function findShaderDataByLoader(param1:BaseLoader) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._shaderData)
         {
            if(_loc2_.loader == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function paras() : void
      {
         this.parasSets(this._currentComponentSet..set);
         this.parasComponent(this._currentComponentSet..component);
         this.parasCustomObject(this._currentComponentSet..custom);
         if(this._currentComponentSet.hasOwnProperty("tips"))
         {
            this.parasTipStyle(this._currentComponentSet.tips);
         }
         if(this._currentComponentSet.shaderFilters.length() > 0)
         {
         }
         this.parasBitmapDataSets(this._currentComponentSet..bitmapData);
         this.parasBitmapSets(this._currentComponentSet..bitmap);
      }
      
      private function parasBitmapDataSets(param1:XMLList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length())
         {
            this._bitmapSets[String(param1[_loc2_].@resourceLink)] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      private function parasBitmapSets(param1:XMLList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length())
         {
            this._bitmapSets[String(param1[_loc2_].@resourceLink)] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      private function parasComponent(param1:XMLList) : void
      {
         var _loc3_:Error = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length())
         {
            if(this._componentStyle[String(param1[_loc2_].@stylename)] != null)
            {
               throw new Error("样式重名。。。请注意检查!!!!!!!!" + String(param1[_loc2_].@stylename));
            }
            param1[_loc2_].@componentModule = this._currentComponentSet.@name;
            this._componentStyle[String(param1[_loc2_].@stylename)] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      private function parasCustomObject(param1:XMLList) : void
      {
         var _loc3_:Error = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length())
         {
            if(this._customObjectStyle[String(param1[_loc2_].@stylename)] != null)
            {
               throw new Error("样式重名。。。请注意检查!!!!!!!!" + String(param1[_loc2_].@stylename));
            }
            this._customObjectStyle[String(param1[_loc2_].@stylename)] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      private function parasSets(param1:XMLList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length())
         {
            if(String(param1[_loc2_].@type) == ClassUtils.COLOR_MATIX_FILTER)
            {
               this._styleSets[String(param1[_loc2_].@stylename)] = ClassUtils.CreatInstance(param1[_loc2_].@type,[ComponentFactory.parasArgs(param1[_loc2_].@args)]);
            }
            else
            {
               this._styleSets[String(param1[_loc2_].@stylename)] = ClassUtils.CreatInstance(param1[_loc2_].@type,ComponentFactory.parasArgs(param1[_loc2_].@args));
            }
            ObjectUtils.copyPorpertiesByXML(this._styleSets[String(param1[_loc2_].@stylename)],param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function parasTipStyle(param1:XMLList) : void
      {
         var _loc2_:Array = String(param1[0].@alltips).split(",");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(this._allTipStyles.indexOf(_loc2_[_loc3_]) == -1)
            {
               this._allTipStyles.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
      }
   }
}
