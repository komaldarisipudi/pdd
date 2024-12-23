from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt  # Import Bcrypt for password hashing
from sqlalchemy.orm import class_mapper, ColumnProperty
from sqlalchemy.orm.attributes import InstrumentedAttribute
from sqlalchemy import func
from sqlalchemy import text
from sqlalchemy import Integer
import os
from werkzeug.utils import secure_filename

import base64
import os
import uuid
from flask_restful import Api
from datetime import datetime, timedelta
from textblob import TextBlob

import pymysql
pymysql.install_as_MySQLdb()

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://komal:2305@192.168.127.198/bus'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'komal'
bcrypt = Bcrypt(app)

db = SQLAlchemy(app)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


#----------------------------------------api calls here---------------------------------------------------------------

class AdminLogin(db.Model):
    __tablename__ = 'adminlogin'
    email = db.Column(db.String(255), primary_key=True, nullable=False, unique=True)
    password = db.Column(db.String(255), nullable=False)

    def __init__(self, email, password):
        self.email = email
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')

# Route for admin login

# Admin Login Route (verify hashed password)
@app.route('/admin/login', methods=['POST'])
def admin_login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        # Find the admin
        admin = AdminLogin.query.filter_by(email=email).first()

        # Check if the admin exists
        if not admin:
            return jsonify({'error': 'Invalid email or password'}), 401

        # Check if the stored password is a bcrypt hash
        if len(admin.password) == 60 and admin.password.startswith('$2b$'):
            # If the stored password is bcrypt hashed, check it
            if bcrypt.check_password_hash(admin.password, password):
                return jsonify({'message': 'Login successful'}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401
        else:
            # If the stored password is not hashed (plain text), hash and update
            if admin.password == password:
                hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
                admin.password = hashed_password
                db.session.commit()
                return jsonify({'message': 'Login successful, password has been hashed and updated'}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        print(f"Error in admin_login endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/admin/forgot', methods=['POST'])
def admin_forgot():
    try:
        data = request.get_json()
        email = data.get('email')
        old_password = data.get('old_password')
        new_password = data.get('new_password')
        confirm_password = data.get('confirm_password')

        if not email or not old_password or not new_password or not confirm_password:
            return jsonify({'error': 'All fields are required'}), 400

        # Check if new password and confirm password match
        if new_password != confirm_password:
            return jsonify({'error': 'New password and confirm password do not match'}), 400

        # Find the admin by email
        admin = AdminLogin.query.filter_by(email=email).first()

        if not admin:
            return jsonify({'error': 'Admin not found'}), 404

        # Check if the old password is correct
        if bcrypt.check_password_hash(admin.password, old_password):
            # Hash the new password
            hashed_new_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
            admin.password = hashed_new_password
            db.session.commit()
            return jsonify({'message': 'Password updated successfully'}), 200
        else:
            return jsonify({'error': 'Incorrect old password'}), 401

    except Exception as e:
        print(f"Error in admin_forgot endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class users(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    phone_number = db.Column(db.String(15), nullable=False)
    date_of_birth = db.Column(db.Date, nullable=False)
    status = db.Column(db.String(20), default='Unblocked')

@app.route('/admin/users', methods=['POST'])
def update_user_status():
    try:
        data = request.get_json()
        email = data.get('email')
        status = data.get('status')

        if not email or not status:
            return jsonify({'error': 'Email and status are required'}), 400

        # Find the user by email
        user = users.query.filter_by(email=email).first()

        if not user:
            return jsonify({'error': 'User not found'}), 404

        # Update the status
        user.status = status
        db.session.commit()

        return jsonify({'message': f"User status updated to {status}"}), 200

    except Exception as e:
        print(f"Error in update_user_status: {str(e)}")
        return jsonify({'error': str(e)}), 500

class owners(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    phone_number = db.Column(db.String(15), nullable=False)
    status = db.Column(db.String(20), default='Unblocked')

@app.route('/admin/owners', methods=['POST'])
def update_owner_status():
    try:
        data = request.get_json()
        email = data.get('email')
        status = data.get('status')

        if not email or not status:
            return jsonify({'error': 'Email and status are required'}), 400

        # Find the owner by email
        owner = owners.query.filter_by(email=email).first()

        if not owner:
            return jsonify({'error': 'Owner not found'}), 404

        # Update the status
        owner.status = status
        db.session.commit()

        return jsonify({'message': f"Owner status updated to {status}"}), 200

    except Exception as e:
        print(f"Error in update_owner_status: {str(e)}")
        return jsonify({'error': str(e)}), 500

class OwnerLogin(db.Model):
    __tablename__ = 'ownerlogin'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(255), nullable=False, unique=True)
    password = db.Column(db.String(255), nullable=False)

@app.route('/owner/login', methods=['POST'])
def owner_login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        # Find the owner
        owner = OwnerLogin.query.filter_by(email=email).first()

        # Check if the owner exists
        if not owner:
            return jsonify({'error': 'Invalid email or password'}), 401

        # Check if the stored password is a bcrypt hash
        if len(owner.password) == 60 and owner.password.startswith('$2b$'):
            # If the stored password is bcrypt hashed, check it
            if bcrypt.check_password_hash(owner.password, password):
                return jsonify({'message': 'Login successful'}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401
        else:
            # If the stored password is not hashed (plain text), hash and update
            if owner.password == password:
                hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
                owner.password = hashed_password
                db.session.commit()
                return jsonify({'message': 'Login successful, password has been hashed and updated'}), 200
            else:
                return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        print(f"Error in owner_login endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class BusDetails(db.Model):
    __tablename__ = 'add_bus_details'
    bus_number = db.Column(db.String(100), primary_key=True, nullable=False, unique=True)
    bus_company = db.Column(db.String(100), nullable=False)
    seating_type = db.Column(db.String(50), nullable=False)
    no_of_seats = db.Column(db.Integer, nullable=False)
    seating_arrangement = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    ac_available = db.Column(db.Boolean, default=False)
    charging_available = db.Column(db.Boolean, default=False)
    tv_available = db.Column(db.Boolean, default=False)

@app.route('/add/bus/details', methods=['POST'])
def add_bus_details():
    try:
        data = request.get_json()

        bus_number = data.get('bus_number')
        bus_company = data.get('bus_company')
        seating_type = data.get('seating_type')
        no_of_seats = data.get('no_of_seats')
        seating_arrangement = data.get('seating_arrangement')
        price = data.get('price')
        
        # Convert "Yes"/"No" to True/False for boolean fields
        ac_available = data.get('ac_available') == 'Yes'
        charging_available = data.get('charging_available') == 'Yes'
        tv_available = data.get('tv_available') == 'Yes'

        if not bus_number or not bus_company or not seating_type or not no_of_seats or not seating_arrangement or not price:
            return jsonify({'error': 'All fields are required'}), 400

        # Check if the bus already exists
        existing_bus = BusDetails.query.filter_by(bus_number=bus_number).first()

        if existing_bus:
            # Update the existing bus details
            existing_bus.bus_company = bus_company
            existing_bus.seating_type = seating_type
            existing_bus.no_of_seats = no_of_seats
            existing_bus.seating_arrangement = seating_arrangement
            existing_bus.price = price
            existing_bus.ac_available = ac_available
            existing_bus.charging_available = charging_available
            existing_bus.tv_available = tv_available
            db.session.commit()
            return jsonify({'message': 'Bus details updated successfully'}), 200
        else:
            # Add new bus details
            new_bus = BusDetails(
                bus_number=bus_number,
                bus_company=bus_company,
                seating_type=seating_type,
                no_of_seats=no_of_seats,
                seating_arrangement=seating_arrangement,
                price=price,
                ac_available=ac_available,
                charging_available=charging_available,
                tv_available=tv_available
            )
            db.session.add(new_bus)
            db.session.commit()
            return jsonify({'message': 'Bus details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_bus_details: {str(e)}")
        return jsonify({'error': str(e)}), 500


class TravelDetails(db.Model):
    __tablename__ = 'travel_details'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    starting_point = db.Column(db.String(255), nullable=False)
    boarding_point = db.Column(db.String(255), nullable=False)
    time = db.Column(db.String(255), nullable=False)  # Changed to String

@app.route('/add/travel/details', methods=['POST'])
def add_travel_details():
    try:
        data = request.get_json()


        starting_point = data.get('starting_point')
        boarding_point = data.get('boarding_point')
        time = data.get('time')

        # Check if all fields are provided
        if not starting_point or not boarding_point or not time:
            return jsonify({'error': 'All fields are required'}), 400

        print(f"Received data: {data}")  # Log the received data

        # Check if a record with the same starting_point and boarding_point exists
        existing_entry = TravelDetails.query.filter_by(
            starting_point=starting_point, boarding_point=boarding_point).first()

        if existing_entry:
            print("Updating existing entry.")  # Log the update action
            existing_entry.time = time
            db.session.commit()
            return jsonify({'message': 'Travel details updated successfully'}), 200
        else:
            print("Adding a new entry.")  # Log the add action
            new_travel_detail = TravelDetails(
                starting_point=starting_point,
                boarding_point=boarding_point,
                time=time
            )
            db.session.add(new_travel_detail)
            db.session.commit()
            return jsonify({'message': 'Travel details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_travel_details: {str(e)}")  # Log the exception
        return jsonify({'error': str(e)}), 500

class middlepointdetails(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    middle_point = db.Column(db.String(100), nullable=False)
    point = db.Column(db.String(100), nullable=False)
    time = db.Column(db.String(50), nullable=False)


@app.route('/add/middle/details', methods=['POST'])
def add_middle_details():
    try:
        # Get data from request body
        data = request.get_json()
        middle_point = data.get('middle_point')
        point = data.get('point')
        time = data.get('time')

        # Check if all fields are provided
        if not middle_point or not point or not time:
            return jsonify({'error': 'All fields (middle_point, point, time) are required'}), 400

        # Log the received data
        print(f"Received data: {data}")

        # Check if a record with the same middle_point and point already exists
        existing_entry = middlepointdetails.query.filter_by(middle_point=middle_point, point=point).first()

        if existing_entry:
            # If the entry exists, update the time
            print("Updating existing entry.")
            existing_entry.time = time
            db.session.commit()
            return jsonify({'message': 'Middle point details updated successfully'}), 200
        else:
            # If the entry does not exist, add a new record
            print("Adding new entry.")
            new_entry = middlepointdetails(middle_point=middle_point, point=point, time=time)
            db.session.add(new_entry)
            db.session.commit()
            return jsonify({'message': 'Middle point details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_middle_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

class endingpointdetails(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    ending_point = db.Column(db.String(100), nullable=False)
    point = db.Column(db.String(100), nullable=False)
    time = db.Column(db.String(50), nullable=False)

@app.route('/add/endingpoint/details', methods=['POST'])
def add_endingpoint_details():
    try:
        # Get data from the request body
        data = request.get_json()
        ending_point = data.get('ending_point')
        point = data.get('point')
        time = data.get('time')

        # Check if all fields are provided
        if not ending_point or not point or not time:
            return jsonify({'error': 'All fields (ending_point, point, time) are required'}), 400

        # Log the received data for debugging
        print(f"Received data: {data}")

        # Check if a record with the same ending_point and point already exists
        existing_entry = endingpointdetails.query.filter_by(ending_point=ending_point, point=point).first()

        if existing_entry:
            # If the entry exists, update the time
            print("Updating existing entry.")
            existing_entry.time = time
            db.session.commit()
            return jsonify({'message': 'Ending point details updated successfully'}), 200
        else:
            # If the entry does not exist, add a new record
            print("Adding new entry.")
            new_entry = endingpointdetails(ending_point=ending_point, point=point, time=time)
            db.session.add(new_entry)
            db.session.commit()
            return jsonify({'message': 'Ending point details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_endingpoint_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get/details', methods=['GET'])
def get_bus_details():
    try:
        # Query all records from the AddBusDetails table
        bus_details = BusDetails.query.all()
        
        # If no data is found
        if not bus_details:
            return jsonify({'message': 'No bus details found'}), 404

        # Prepare the list of bus details
        bus_data = []
        for bus in bus_details:
            bus_data.append({
                'bus_number': bus.bus_number,
                'bus_company': bus.bus_company,
                'no_of_seats': bus.no_of_seats,
                'seating_type':bus.seating_type,
                'ac_available':bus.ac_available
            })

        # Return the bus details in JSON format
        return jsonify({'bus_details': bus_data}), 200

    except Exception as e:
        print(f"Error in get_bus_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get/travel_details', methods=['GET'])
def get_travel_details():
    try:
        # Query all records from the TravelDetails table
        travel_details = TravelDetails.query.all()
        
        # If no data is found
        if not travel_details:
            return jsonify({'message': 'No travel details found'}), 404

        # Prepare the list of travel details
        travel_data = []
        for travel in travel_details:
            travel_data.append({
                'starting_point': travel.starting_point,
                'time': travel.time
            })

        # Return the travel details in JSON format
        return jsonify({'travel_details': travel_data}), 200

    except Exception as e:
        print(f"Error in get_travel_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get/ending_details', methods=['GET'])
def get_ending_details():
    try:
        # Query all records from the EndingPointDetails table
        ending_details = endingpointdetails.query.all()
        
        # If no data is found
        if not ending_details:
            return jsonify({'message': 'No ending details found'}), 404

        # Prepare the list of ending details
        ending_data = []
        for ending in ending_details:
            ending_data.append({
                'ending_point': ending.ending_point,
                'time': ending.time
            })

        # Return the ending details in JSON format
        return jsonify({'ending_details': ending_data}), 200

    except Exception as e:
        print(f"Error in get_ending_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

class userdetails(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

@app.route('/user/signup', methods=['POST'])
def user_signup():
    try:
        # Get data from the request
        data = request.get_json()
        name = data.get('name')
        email = data.get('email')
        password = data.get('password')

        # Validate input
        if not name or not email or not password:
            return jsonify({'error': 'Name, email, and password are required'}), 400

        # Check if the email already exists
        existing_user = userdetails.query.filter_by(email=email).first()
        if existing_user:
            return jsonify({'error': 'Email already registered'}), 400

        # Hash the password using Flask-Bcrypt
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        # Create a new user instance
        new_user = userdetails(user_name=name, email=email, password=hashed_password)

        # Add the new user to the database
        db.session.add(new_user)
        db.session.commit()

        return jsonify({'message': 'User registered successfully'}), 201

    except Exception as e:
        print(f"Error in user_signup endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

    except Exception as e:
        print(f"Error in user_signup endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/user/signin', methods=['POST'])
def user_signin():
    try:
        # Get data from the request
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        # Validate input
        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        # Find the user by email
        user = userdetails.query.filter_by(email=email).first()

        # Check if the user exists
        if not user:
            return jsonify({'error': 'Invalid email or password'}), 401

        # Check if the password matches (compare hashed password with input password)
        if bcrypt.check_password_hash(user.password, password):
            return jsonify({'message': 'Login successful'}), 200
        else:
            return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        print(f"Error in user_signin endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

class Driver(db.Model):
    __tablename__ = 'driver_details'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_name = db.Column(db.String(100), nullable=False)
    phone_no = db.Column(db.String(15), nullable=False)
    second_no = db.Column(db.String(15), nullable=True)
    license_no = db.Column(db.String(50), nullable=False, unique=True)
    email_id = db.Column(db.String(255), nullable=False, unique=True)

@app.route('/add/driver', methods=['POST'])
def add_driver():
    try:
        data = request.get_json()

        driver_name = data.get('driver_name')
        phone_no = data.get('phone_no')
        second_no = data.get('second_no')
        license_no = data.get('license_no')
        email_id = data.get('email_id')

        if not driver_name or not phone_no or not license_no or not email_id:
            return jsonify({'error': 'All required fields are not provided'}), 400

        # Check if the driver already exists
        existing_driver = Driver.query.filter_by(license_no=license_no).first()

        if existing_driver:
            return jsonify({'error': 'Driver with this license number already exists'}), 409

        new_driver = Driver(driver_name=driver_name, phone_no=phone_no, second_no=second_no,
                            license_no=license_no, email_id=email_id)

        db.session.add(new_driver)
        db.session.commit()

        return jsonify({'message': 'Driver details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_driver: {str(e)}")
        return jsonify({'error': str(e)}), 500

class routedetails(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    from_location = db.Column(db.String(100), nullable=False)
    to_location = db.Column(db.String(100), nullable=False)
    travel_date = db.Column(db.Date, nullable=False)

@app.route('/route/details', methods=['POST'])
def add_route_details():
    try:
        # Get data from request body
        data = request.get_json()
        from_location = data.get('from')
        to_location = data.get('to')
        travel_date = data.get('date')

        # Validate input
        if not from_location or not to_location or not travel_date:
            return jsonify({'error': 'All fields (from, to, date) are required'}), 400

        # Convert travel_date to Python date format
        from datetime import datetime
        try:
            travel_date = datetime.strptime(travel_date, '%Y-%m-%d').date()
        except ValueError:
            return jsonify({'error': 'Invalid date format. Use YYYY-MM-DD'}), 400

        # Log received data
        print(f"Adding route details: From {from_location}, To {to_location}, Date {travel_date}")

        # Add new route details to the database
        new_route = routedetails(from_location=from_location, to_location=to_location, travel_date=travel_date)
        db.session.add(new_route)
        db.session.commit()

        return jsonify({'message': 'Route details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_route_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

class findbus(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    bus_number = db.Column(db.String(50), nullable=False)
    company = db.Column(db.String(100), nullable=False)
    seats = db.Column(db.Integer, nullable=False)
    starting_point = db.Column(db.String(100), nullable=False)
    travel_time = db.Column(db.String(100), nullable=False)
    ending_point = db.Column(db.String(100), nullable=False)
    ending_time = db.Column(db.String(100), nullable=False)
    seating_type = db.Column(db.String(100), nullable=False, default="Sleeper")
    ac_available = db.Column(db.Boolean, nullable=False, default=True)

    def as_dict(self):
        return {
            'id': self.id,
            'bus_number': self.bus_number,
            'company': self.company,
            'seats': self.seats,
            'starting_point': self.starting_point,
            'travel_time': self.travel_time,
            'ending_point': self.ending_point,
            'ending_time': self.ending_time,
            'seating_type':self.seating_type,
            'ac_available':self.ac_available
        }

@app.route('/find/bus', methods=['POST'])
def find_bus_details():
    try:
        # Get data from request body
        data = request.get_json()
        bus_number = data.get('bus_number')
        company = data.get('company')
        seats = data.get('seats')
        starting_point = data.get('starting_point')
        travel_time = data.get('travel_time')
        ending_point = data.get('ending_point')
        ending_time = data.get('ending_time')
        seating_type = data.get('seating_type')
        ac_available = data.get('ac_available')

        # Validate input
        if not all([bus_number, company, seats, starting_point, travel_time, ending_point, ending_time]):
            return jsonify({'error': 'All fields are required'}), 400

        # Log received data
        print(f"Adding bus details: {bus_number}, {company}, {seats}, {starting_point}, {travel_time}, {ending_point}, {ending_time},{seating_type},{ac_available}")

        # Add new bus details to the database
        new_bus = findbus(
            bus_number=bus_number,
            company=company,
            seats=seats,
            starting_point=starting_point,
            travel_time=travel_time,  # Store as text directly
            ending_point=ending_point,
            ending_time=ending_time  , # Store as text directly
            seating_type=seating_type,
            ac_available=ac_available
        )
        db.session.add(new_bus)
        db.session.commit()

        return jsonify({'message': 'Bus details added successfully'}), 201

    except Exception as e:
        print(f"Error in add_bus_details: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/get/findbus', methods=['GET'])
def get_findbus():
    try:
        # Query all bus details from the findbus table
        buses = findbus.query.all()
        
        # Convert each bus record to a dictionary
        bus_list = [bus.as_dict() for bus in buses]
        
        # Return the data as a JSON response
        return jsonify({'bus_details': bus_list}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/check/bus', methods=['POST'])
def check_bus():
    bus_number = request.json.get('bus_number')
    if not bus_number:
        return jsonify({'error': 'Bus number is required'}), 400
    
    existing_bus = findbus.query.filter_by(bus_number=bus_number).first()
    if existing_bus:
        return jsonify({'exists': True}), 200
    else:
        return jsonify({'exists': False}), 200

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')