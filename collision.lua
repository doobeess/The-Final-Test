function overlaps(hitbox1, hitbox2)
    if hitbox1.y + hitbox1.height <= hitbox2.y -- Is above
        or hitbox1.y <= hitbox2.y + hitbox2.height -- Is below
        or hitbox1.x + hitbox1.width <= hitbox2.x -- Is left
        or hitbox1.x <= hitbox2.x + hitbox2.width -- Is right
        then
        
        return false
    end

    return true -- Is none of those things, therefore it must be overlapping
end