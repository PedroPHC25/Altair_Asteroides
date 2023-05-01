W,H = love.graphics.getDimensions()

function love.load()
    ship = {}
    ship.r = 30
    ship.x = W/2
    ship.y = 3*H/4
    ship.speed = 400
    ship.img = love.graphics.newImage("Imagens/spiked ship 3. small.blue_.PNG")

    enemies = {}
    timer = 0
    difficult = 5

    fastenemies = {}
    fasttimer = 0
    fastdifficult = 15

    bigenemies = {}
    bigtimer = 0
    bigdifficult = 20

    shots = {}
    timershot = 0

    bigshots = {}
    timerbigshots = 0

    points = 0
    angle = 0
    gameover = 0
    deathsong = 0
    
    shotsound = love.audio.newSource("Sons/pewpew_11.wav", "static")
    explosion = love.audio.newSource("Sons/sfx_explosionGoo.ogg", "static")
    song = love.audio.newSource("Sons/space walk.ogg", "stream")
    death = love.audio.newSource("Sons/hjm-big_explosion_3.wav", "static")
    wallpaper = love.graphics.newImage("Imagens/R.jpg")
    font = love.graphics.newFont("Imagens/Boxy-Bold.ttf", 40)
    font2 = love.graphics.newFont("Imagens/Boxy-Bold.ttf", 20)
    bigshotsound = love.audio.newSource("Sons/105016__julien-matthey__jm-fx-fireball-01.wav", "static")
    bigshotimg = love.graphics.newImage("Imagens/shot_fireball.png")
end

function love.update(dt)
    if gameover == 0 then
        move(dt)
        enemygen(dt)
        enemymove(dt)
        enemycollision(dt)
        shotsgen(dt)
        shotsmove(dt)
        shotscollision(dt)
        fastenemygen(dt)
        fastenemymove(dt)
        fastenemycollision(dt)
        bigenemygen(dt)
        bigenemymove(dt)
        bigenemycollision(dt)
        bigshotsgen(dt)
        bigshotsmove(dt)
        bigshotscollision(dt)
    end

    audio(dt)
    reset(dt)

    angle = angle + 0.1
    posx = love.math.random(-200, 200)
    posy = love.math.random(0, 200)
end

-- Player

function move(dt)
    if love.keyboard.isDown('w') and ship.y-ship.r > 0 then
        ship.y = ship.y - ship.speed * dt
    end
    if love.keyboard.isDown('s') and ship.y+ship.r < H then
        ship.y = ship.y + ship.speed * dt
    end
    if love.keyboard.isDown('a') and ship.x-ship.r > 0 then
        ship.x = ship.x - ship.speed * dt
    end
    if love.keyboard.isDown('d') and ship.x+ship.r < W then
        ship.x = ship.x + ship.speed * dt
    end
    if love.keyboard.isDown('w') and love.keyboard.isDown('a') and ship.y-ship.r > 0 and ship.x-ship.r > 0 then
        ship.y = ship.y - ship.speed * (1/math.sqrt(2) - 1) * dt 
        ship.x = ship.x - ship.speed * (1/math.sqrt(2) - 1) * dt 
    end
    if love.keyboard.isDown('w') and love.keyboard.isDown('d') and ship.y-ship.r > 0 and ship.x+ship.r < W then
        ship.y = ship.y - ship.speed * (1/math.sqrt(2) - 1) * dt 
        ship.x = ship.x + ship.speed * (1/math.sqrt(2) - 1) * dt 
    end
    if love.keyboard.isDown('s') and love.keyboard.isDown('a') and ship.y+ship.r < H and ship.x-ship.r > 0 then
        ship.y = ship.y + ship.speed * (1/math.sqrt(2) - 1) * dt 
        ship.x = ship.x - ship.speed * (1/math.sqrt(2) - 1) * dt 
    end
    if love.keyboard.isDown('s') and love.keyboard.isDown('d') and ship.y+ship.r < H and ship.x+ship.r < W then
        ship.y = ship.y + ship.speed * (1/math.sqrt(2) - 1) * dt 
        ship.x = ship.x + ship.speed * (1/math.sqrt(2) - 1) * dt 
    end
end

-- Inimigos comuns

function enemygen(dt)
    timer = timer + 1*dt
    if timer > difficult then
        enemy = {x = W/2 + posx, y = H/10 + posy, r = 25, xspeed = 200, yspeed = 200, img = love.graphics.newImage("Imagens/asteroid.png")}
        table.insert(enemies, enemy)
        timer = 0
        if difficult > 0.5 then
            difficult = difficult - 0.1
        end
    end
end

function enemymove(dt)
    for i, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.xspeed*dt
        enemy.y = enemy.y + enemy.yspeed*dt
        if enemy.x > W - enemy.r or enemy.x < enemy.r then
            enemy.xspeed = enemy.xspeed*(-1)
        end
        if enemy.y > H - enemy.r or enemy.y < enemy.r then
            enemy.yspeed = enemy.yspeed*(-1)
        end
    end
end

function enemycollision(dt)
    for i, enemy in ipairs(enemies) do
        if math.sqrt((enemy.x - ship.x)^2 + (enemy.y - ship.y)^2) < enemy.r + ship.r then
            gameover = 1
        end
    end
end

-- Inimigos velozes

function fastenemygen(dt)
    fasttimer = fasttimer + 1*dt
    if fasttimer > fastdifficult then
        fastenemy = {x = W/2 + posx, y = H/10 + posy, r = 15, xspeed = 400, yspeed = 400, img = love.graphics.newImage("Imagens/asteroid2.png")}
        table.insert(fastenemies, fastenemy)
        fasttimer = 0
        if fastdifficult > 2 then
            fastdifficult = fastdifficult - 0.1
        end
    end
end

function fastenemymove(dt)
    for i, fastenemy in ipairs(fastenemies) do
        fastenemy.x = fastenemy.x + fastenemy.xspeed*dt
        fastenemy.y = fastenemy.y + fastenemy.yspeed*dt
        if fastenemy.x > W - fastenemy.r or fastenemy.x < fastenemy.r then
            fastenemy.xspeed = fastenemy.xspeed*(-1)
        end
        if fastenemy.y > H - fastenemy.r or fastenemy.y < fastenemy.r then
            fastenemy.yspeed = fastenemy.yspeed*(-1)
        end
    end
end

function fastenemycollision(dt)
    for i, fastenemy in ipairs(fastenemies) do
        if math.sqrt((fastenemy.x - ship.x)^2 + (fastenemy.y - ship.y)^2) < fastenemy.r + ship.r then
            gameover = 1
        end
    end
end

-- Inimigos grandes

function bigenemygen(dt)
    bigtimer = bigtimer + 1*dt
    if bigtimer > bigdifficult then
        bigenemy = {x = W/2 + posx, y = H/10 + posy, r = 40, xspeed = 100, yspeed = 100, life = 5, img = love.graphics.newImage("Imagens/asteroid_gold.png")}
        table.insert(bigenemies, bigenemy)
        bigtimer = 0
        if bigdifficult > 5 then
            bigdifficult = bigdifficult - 0.1
        end
    end
end

function bigenemymove(dt)
    for i, bigenemy in ipairs(bigenemies) do
        bigenemy.x = bigenemy.x + bigenemy.xspeed*dt
        bigenemy.y = bigenemy.y + bigenemy.yspeed*dt
        if bigenemy.x > W - bigenemy.r or bigenemy.x < bigenemy.r then
            bigenemy.xspeed = bigenemy.xspeed*(-1)
        end
        if bigenemy.y > H - bigenemy.r or bigenemy.y < bigenemy.r then
            bigenemy.yspeed = bigenemy.yspeed*(-1)
        end
    end
end

function bigenemycollision(dt)
    for i, bigenemy in ipairs(bigenemies) do
        if math.sqrt((bigenemy.x - ship.x)^2 + (bigenemy.y - ship.y)^2) < bigenemy.r + ship.r then
            gameover = 1
        end
    end
end

-- Tiros

function shotsgen(dt)
    timershot = timershot + 1*dt
    if love.keyboard.isDown("space") and timershot > 0.5 then
        shot = {x = ship.x, y = ship.y, r = 5, speed = 600, img = love.graphics.newImage("Imagens/beams.png")}
        table.insert(shots, shot)
        timershot = 0
        love.audio.play(shotsound)
    end
end

function shotsmove(dt)
    for i, shot in ipairs(shots) do
        shot.y = shot.y - shot.speed*dt
        if shot.y < -10 then
            table.remove(shots, i)
        end
    end
end

function shotscollision(dt)
    for i, enemy in ipairs(enemies) do
        for j, shot in ipairs(shots) do
            if math.sqrt((enemy.x - shot.x)^2 + (enemy.y - shot.y)^2) < enemy.r + shot.r then
                table.remove(enemies, i)
                table.remove(shots, j)
                points = points + 1
                love.audio.play(explosion)
            end
        end
    end
    for i, fastenemy in ipairs(fastenemies) do
        for j, shot in ipairs(shots) do
            if math.sqrt((fastenemy.x - shot.x)^2 + (fastenemy.y - shot.y)^2) < fastenemy.r + shot.r then
                table.remove(fastenemies, i)
                table.remove(shots, j)
                points = points + 2
                love.audio.play(explosion)
            end
        end
    end
    for i, bigenemy in ipairs(bigenemies) do
        for j, shot in ipairs(shots) do
            if math.sqrt((bigenemy.x - shot.x)^2 + (bigenemy.y - shot.y)^2) < bigenemy.r + shot.r then
                bigenemy.life = bigenemy.life - 1
                table.remove(shots, j)
                love.audio.play(explosion)
            end
        end
        if bigenemy.life == 0 then
            table.remove(bigenemies, i)
            points = points + 3
        end
    end
end

-- Tiros grandes

function bigshotsgen(dt)
    timerbigshots = timerbigshots + 1*dt
    if love.keyboard.isDown("b") and timerbigshots > 10 then
        bigshot = {x = ship.x, y = ship.y, r = 20, speed = 200, img = love.graphics.newImage("Imagens/shot_fireball.png")}
        table.insert(bigshots, bigshot)
        timerbigshots = 0
        love.audio.play(bigshotsound)
    end
end

function bigshotsmove(dt)
    for i, bigshot in ipairs(bigshots) do
        bigshot.y = bigshot.y - bigshot.speed*dt
        if bigshot.y < -30 then
            table.remove(bigshots, i)
        end
    end
end

function bigshotscollision(dt)
    for i, enemy in ipairs(enemies) do
        for j, bigshot in ipairs(bigshots) do
            if math.sqrt((enemy.x - bigshot.x)^2 + (enemy.y - bigshot.y)^2) < enemy.r + bigshot.r then
                table.remove(enemies, i)
                points = points + 1
                love.audio.play(explosion)
            end
        end
    end
    for i, fastenemy in ipairs(fastenemies) do
        for j, bigshot in ipairs(bigshots) do
            if math.sqrt((fastenemy.x - bigshot.x)^2 + (fastenemy.y - bigshot.y)^2) < fastenemy.r + bigshot.r then
                table.remove(fastenemies, i)
                points = points + 2
                love.audio.play(explosion)
            end
        end
    end
    for i, bigenemy in ipairs(bigenemies) do
        for j, shot in ipairs(bigshots) do
            if math.sqrt((bigenemy.x - bigshot.x)^2 + (bigenemy.y - bigshot.y)^2) < bigenemy.r + bigshot.r then
                bigenemy.life = bigenemy.life - 1
                love.audio.play(explosion)
            end
        end
        if bigenemy.life == 0 then
            table.remove(bigenemies, i)
            points = points + 3
        end
    end
end

-- Reiniciar

function reset(dt)
    if love.keyboard.isDown("r") and gameover == 1 then
        ship.x = W/2
        ship.y = 3*H/4
        enemies = {}
        timer = 0
        difficult = 5
        fastenemies = {}
        fasttimer = 0
        fastdifficult = 15
        bigenemies = {}
        bigtimer = 0
        bigdifficult = 20
        shots = {}
        timershot = 0
        points = 0
        angle = 0
        gameover = 0
        deathsong = 0
        timerbigshots = 0
    end
end

-- Áudio

function audio(dt)
    if gameover == 0 then
        love.audio.play(song)
        song:setLooping(true)
    end
    if gameover == 1 and deathsong == 0 then
        love.audio.stop(song)
        love.audio.play(death)
        deathsong = 1
    end
end

-- Gráficos

function love.draw()
    love.graphics.draw(wallpaper, 0, 0, 0, 2.5, 2.5)
    
    if gameover == 0 then
        love.graphics.draw(ship.img, ship.x, ship.y, 0, 0.5, 0.5, ship.img:getWidth()/2, ship.img:getHeight()/2)
        love.graphics.setFont(font)
        love.graphics.print(points, W/2, H/10)
        for i, enemy in ipairs(enemies) do
            love.graphics.draw(enemy.img, enemy.x, enemy.y, angle, 0.5, 0.5, enemy.img:getWidth()/2, enemy.img:getHeight()/2)
        end
        for i, shot in ipairs(shots) do
            love.graphics.draw(shot.img, shot.x, shot.y, 0, 0.3, 0.3, shot.img:getWidth()/2, shot.img:getHeight()/2)
        end
        for i, fastenemy in ipairs(fastenemies) do
            love.graphics.draw(fastenemy.img, fastenemy.x, fastenemy.y, angle, 0.25, 0.25, fastenemy.img:getWidth()/2, fastenemy.img:getHeight()/2)
        end
        for i, bigenemy in ipairs(bigenemies) do
            love.graphics.draw(bigenemy.img, bigenemy.x, bigenemy.y, angle, 1, 1, bigenemy.img:getWidth()/2, bigenemy.img:getHeight()/2)
        end
        for i, bigshot in ipairs(bigshots) do
            love.graphics.draw(bigshot.img, bigshot.x, bigshot.y, 0, 3, 3, bigshot.img:getWidth()/2, bigshot.img:getHeight()/2)
        end
        if timerbigshots > 10 then
            love.graphics.draw(bigshotimg, 9*W/10, H/10)
        end
    end
    if gameover == 1 then
        love.graphics.setFont(font2)
        if points < 5 then
            love.graphics.print("Se acalma. Tenta de novo.", W/3.5, H/3)
        end
        if points > 4 and points < 10 then
            love.graphics.print("Foi bem, mas da pra melhorar.", W/4, H/3)
        end
        if points > 9 then
            love.graphics.print("Parabens! Mas voce pode se superar!", W/5.5, H/3)
        end
        love.graphics.print("Aperte R para reiniciar", W/3.4, 2*H/3)
        love.graphics.setFont(font)
        love.graphics.print(points, W/2, H/2)
    end
end