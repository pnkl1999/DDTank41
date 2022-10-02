<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class MemAccount extends Model
{
    protected $table='Mem_Account';
    
    protected $primaryKey='id';
    
    public $timestamps = false;
    
    protected $guarded = ['id'];
}