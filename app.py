from flask import Flask, redirect, url_for, render_template, request, session
from datetime import timedelta, datetime
import random

import mysql.connector

mydb=mysql.connector.connect(host="localhost",user="root",passwd="1234", database="quickserve" )
app = Flask (__name__)
app.permanent_session_lifetime = timedelta(days = 1)
app.secret_key = "quickServe@123"
mycursor = mydb.cursor()

order = {}

@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        role = request.form["dropdown"]
        phone_no = request.form['phone_no']
        password = request.form['password']
        if role == 'admin':
            if(phone_no == '8882509813' and password == 'aakash@21'):
                return redirect(url_for("admin"))
            else:
                session['message'] = 'Wrong phone no or password'
                return redirect(url_for('login'))
        else:
            q = f"SELECT * FROM {role} WHERE {role}_phone_no='{phone_no}';"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            # print(myresult)
            if(len(myresult)==1 and myresult[0][2]==phone_no and myresult[0][4] == password):
                session.permanent = True
                session["user"] = myresult[0]
                session['logged_in'] = True
                if(role == "restaurant"):
                    q = f"select access_status from restaurant where restaurant_id='{myresult[0][0]}'"
                    mycursor.execute(q)
                    result = mycursor.fetchall()
                    print(result)
                    if(result[0][0] == "YES"):
                        return redirect(url_for(f"{role}", button='login'))
                    else:
                        session['message'] = 'Access Denied By Admin'
                        return redirect(url_for('login'))
                return redirect(url_for(f"{role}"))
            else:
                session['message'] = 'Wrong phone no or password'
                return redirect(url_for('login'))
    return render_template('login.html', message=session.pop('message', ''))

@app.route("/signup", methods= ["POST", "GET"])
def signup():
    if(request.method == "POST"):
        role = request.form["dropdown"]
        name = request.form["name"]
        phone_no = request.form["phone_no"]
        address = request.form["address"]
        password = request.form["password"]
        # print(role, name, phone_no, address, password)
        q = f"insert into {role} ({role}_name, {role}_phone_no, {role}_address, {role}_password) values('{name}', '{phone_no}', '{address}', '{password}');"
        mycursor.execute(q)
        mydb.commit()
        # print(q)
        return redirect(url_for("login"))
    return render_template("signup.html")


@app.route("/customer", methods=["POST", "GET"])
def customer():
    if "user" in session:
        # mycursor = mydb.cursor()
        q = f"Select * from restaurant where access_status='YES';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("customer.html", x = myresult)
    else:
        return redirect(url_for("login"))


@app.route("/customer/food", methods=["POST", "GET"])
def customerfood():
    if "user" in session:
        button_clicked = request.args.get('button')
        if(button_clicked == "food"):
            res_id = request.form['itemId']
            q = f"SELECT f.*, r.restaurant_name FROM food f JOIN restaurant r ON f.res_id = r.restaurant_id WHERE restaurant_id = '{res_id}';"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            return render_template("customerfood.html", x = myresult)
        else:
            food_id = request.form['itemId']
            quantity = request.form['quantity']
            q = f"Select res_id from food where food_id={food_id}"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            if food_id in order:
                order[food_id].append(quantity)
            else:
                order[food_id] = [quantity]
            res_id = myresult[0][0]
            print(order)
            q = f"SELECT f.*, r.restaurant_name FROM food f JOIN restaurant r ON f.res_id = r.restaurant_id WHERE restaurant_id = '{res_id}';"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            return render_template("customerfood.html", x = myresult)
    else:
        return redirect(url_for("login"))

@app.route("/customer/food/orderplaced", methods=["POST", "GET"])
def orderplaced():
    if "user" in session:
        payment_mode = request.form.get('payment_mode')
        q = f"select customer_id, customer_address, customer_name from customer where customer_id = '{session["user"][0]}'"
        mycursor.execute(q)
        result = mycursor.fetchall()
        amount = 0
        current_datetime = datetime.now()
        formatted_datetime = current_datetime.strftime("%Y-%m-%d %H:%M:%S")
        for x in order.keys():
            quant = 0
            q = f"Select * from food where food_id='{x}'"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            res_id = myresult[0][5]
            for i in order[x]:
                i = int(i)
                quant += i
                amount += (i*int(myresult[0][2]))
                q = f"Update food set food_stock={myresult[0][3] - quant} where food_id='{x}';"
                mycursor.execute(q)
                mydb.commit()
        q = f"select delivery_worker_id from delivery_worker;"
        mycursor.execute(q)
        result_temp = mycursor.fetchall()
        l = []
        for i in result_temp:
            l.append(int(i[0]))
        w_id = random.choice(l)
        q = f"insert into orders(ord_time, mode_of_payment, ord_amount, address, cust_id, w_id, res_id) values('{formatted_datetime}', '{payment_mode}', '{amount}', '{result[0][1]}', '{result[0][0]}', '{w_id}', '{res_id}')"
        mycursor.execute(q)
        mydb.commit()
        return render_template("customerplaceorder.html", amnt = amount, name = result[0][2], address = result[0][1], payment = payment_mode)
    else:
        return redirect(url_for("login"))


@app.route("/customer/orders", methods=["POST", "GET"])
def cust_orders():
    if "user" in session:
        # mycursor = mydb.cursor()
        cust_id = session["user"][0]
        q = f"SELECT o.*, r.restaurant_name FROM orders o JOIN restaurant r ON o.res_id = r.restaurant_id WHERE o.cust_id = '{cust_id}';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("customerorders.html", x = myresult)
    else:
        return redirect(url_for("login"))


@app.route("/customer/profile", methods=["POST", "GET"])
def cust_profile():
    if "user" in session:
        # mycursor = mydb.cursor()
        cust_id = session["user"][0]
        q = f"SELECT * from customer where customer_id = '{cust_id}';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("customerprofile.html", x = myresult)
    else:
        return redirect(url_for("login"))

@app.route("/restaurant", methods=["POST", "GET"])
def restaurant():
    if "user" in session:
        res_id = session["user"][0]
        if(request.method == "GET"):
            button_clicked = request.args.get('button')
            if(button_clicked == "login"):
                q = f"SELECT f.*, r.restaurant_name FROM food f JOIN restaurant r ON f.res_id = r.restaurant_id WHERE restaurant_id = '{res_id}';"
                mycursor.execute(q)
                myresult = mycursor.fetchall()
                return render_template("restaurant.html", x = myresult)
        else:
            button_clicked = request.args.get('button')
            if(button_clicked == "login"):
                food_name = request.form.get("foodName")
                food_price = request.form.get("foodPrice")
                food_stock = request.form.get("foodStock")
                is_veg = request.form.get("isVeg")
                val = 0
                if is_veg:
                    val = 1
                q = f"insert into food(food_name, food_price, food_stock, food_isVeg, res_id) values('{food_name}', '{food_price}', '{food_stock}', '{val}', '{res_id}');"
                mycursor.execute(q)
                mydb.commit()
                q = f"SELECT f.*, r.restaurant_name FROM food f JOIN restaurant r ON f.res_id = r.restaurant_id WHERE restaurant_id = '{res_id}';"
                mycursor.execute(q)
                myresult = mycursor.fetchall()
                return render_template("restaurant.html", x = myresult)
            else:
                food_id = request.form['itemId']
                stock = request.form['quantity']
                price = request.form['price']
                # print(food_id,stock, price)
                q = f"select food_stock from food where food_id='{food_id}';"
                mycursor.execute(q)
                myresult = mycursor.fetchall()
                # print(myresult[0][0])
                av_stock = int(myresult[0][0]) + int(stock)
                # print(av_stock)
                q = f"update food set food_stock = '{av_stock}', food_price='{price}' where food_id='{food_id}';"
                mycursor.execute(q)
                mydb.commit()
                q = f"SELECT f.*, r.restaurant_name FROM food f JOIN restaurant r ON f.res_id = r.restaurant_id WHERE restaurant_id = '{res_id}';"
                mycursor.execute(q)
                myresult = mycursor.fetchall()
                return render_template("restaurant.html", x = myresult)
    else:
        return redirect(url_for("login"))


@app.route("/restaurant/addfood", methods=["POST", "GET"])
def addfood():
    if "user" in session:
        if(request.method == "POST"):
            res_id = session["user"][0]
            
            q = f"SELECT * from restaurant where restaurant_id = '{res_id}';"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            return render_template("restaurantprofile.html", x = myresult)
        return render_template("restaurantaddfood.html")
    else:
        return redirect(url_for("login"))


@app.route("/restaurant/profile", methods=["POST", "GET"])
def res_profile():
    if "user" in session:
        # mycursor = mydb.cursor()
        res_id = session["user"][0]
        q = f"SELECT * from restaurant where restaurant_id = '{res_id}';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("restaurantprofile.html", x = myresult)
    else:
        return redirect(url_for("login"))

@app.route("/restaurant/orders", methods=["POST", "GET"])
def res_orders():
    if "user" in session:
        # mycursor = mydb.cursor()
        res_id = session["user"][0]
        q = f"SELECT o.*, c.customer_name FROM orders o JOIN customer c ON o.cust_id = c.customer_id WHERE o.res_id = '{res_id}';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("restaurantorders.html", x = myresult)
    else:
        return redirect(url_for("login"))

@app.route("/delivery_worker", methods=["POST", "GET"])
def delivery_worker():
    if "user" in session:
        w_id = session["user"][0]
        if(request.method == "GET"):
            q = f"SELECT o.*, r.restaurant_name FROM orders o JOIN restaurant r ON o.res_id = r.restaurant_id WHERE o.w_id = '{w_id}' and o.ord_status='On The Way';"
            mycursor.execute(q)
            myresult = mycursor.fetchall()
            print(myresult)
            return render_template("delivery.html", x = myresult)
        else:
            ord_id = request.form['itemId']
            q = f"update orders set ord_status='Delivered' where ord_id='{ord_id}';"
            mycursor.execute(q)
            mydb.commit()
            return redirect(url_for("delivery_worker"))
    else:
        return redirect(url_for("login"))

@app.route("/delivery_worker/profile", methods=["POST", "GET"])
def delivery_worker_profile():
    if "user" in session:
        # mycursor = mydb.cursor()
        w_id = session["user"][0]
        q = f"SELECT * from delivery_worker where delivery_worker_id = '{w_id}';"
        mycursor.execute(q)
        myresult = mycursor.fetchall()
        return render_template("deliveryprofile.html", x = myresult)
    else:
        return redirect(url_for("login"))


@app.route("/admin", methods=["POST", "GET"])
def admin():
    if "user" in session:
        if(request.method == "GET"):
            q = f"SELECT * from restaurant where access_status = 'NOT GIVEN';"
            mycursor.execute(q)
            myresult1 = mycursor.fetchall()
            q = f"SELECT * from delivery_worker;"
            mycursor.execute(q)
            myresult2 = mycursor.fetchall()
            return render_template("admin.html", x = myresult1, y=myresult2)
        else:
            button_clicked = request.args.get("button")
            if(button_clicked == "res"):
                res_id = request.form["itemId"]
                q = f"update restaurant set access_status='YES' where restaurant_id='{res_id}';"
                mycursor.execute(q)
                mydb.commit()
                return redirect(url_for("admin"))
            else:
                w_id = request.form["itemId"]
                salary = request.form["salary"]
                q = f"update delivery_worker set delivery_worker_salary='{salary}' where delivery_worker_id = '{w_id}'"
                mycursor.execute(q)
                mydb.commit()
                return redirect(url_for("admin"))
    else:
        return redirect(url_for("login"))

if __name__ == '__main__':
    app.run(debug=True)